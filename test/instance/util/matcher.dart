// Copyright 2014, the Dart project authors. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:

//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of Google Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'package:flutter_test/flutter_test.dart';

class FunctionMatcher<T> extends CustomMatcher {
  FunctionMatcher(final String name, this._feature, final T matcher)
      : super('`$name`:', '`$name`', matcher);
  final Object Function(T value) _feature;

  @override
  Object featureValueOf(covariant final T actual) => _feature(actual);
}

class HavingMatcher<T> implements TypeMatcher<T> {
  HavingMatcher(final TypeMatcher<T> parent, final String description,
      final Object Function(T) feature, final T matcher,
      [final Iterable<FunctionMatcher<T>>? existing,])
      : _parent = parent,
        _functionMatchers = <FunctionMatcher<T>>[
          ...?existing,
          FunctionMatcher<T>(description, feature, matcher),
        ];
  final TypeMatcher<T> _parent;
  final List<FunctionMatcher<T>> _functionMatchers;

  @override
  TypeMatcher<T> having(
          final Object Function(T) feature, final String description, final T matcher,) =>
      HavingMatcher<T>(
          _parent, description, feature, matcher, _functionMatchers,);

  @override
  bool matches(final dynamic item, final Map<dynamic, dynamic> matchState) {
    for (final Matcher matcher
        in <Matcher>[_parent].followedBy(_functionMatchers)) {
      if (!matcher.matches(item, matchState)) {
        addStateInfo(matchState, <String, Matcher>{'matcher': matcher});
        return false;
      }
    }
    return true;
  }

  @override
  Description describeMismatch(
    final dynamic item,
    final Description mismatchDescription,
    final Map<dynamic, dynamic> matchState,
    final bool verbose,
  ) {
    final Matcher matcher = matchState['matcher']! as Matcher;
    matcher.describeMismatch(item, mismatchDescription,
        matchState['state']! as Map<dynamic, dynamic>, verbose,);
    return mismatchDescription;
  }

  @override
  Description describe(final Description description) => description
      .add('')
      .addDescriptionOf(_parent)
      .add(' with ')
      .addAll('', ' and ', '', _functionMatchers);
}

class TypeMatcher<T> extends Matcher {
  const TypeMatcher();

  TypeMatcher<T> having(
          final Object Function(T) feature, final String description, final T matcher,) =>
      HavingMatcher<T>(this, description, feature, matcher);

  @override
  Description describe(final Description description) {
    final String name = _stripDynamic(T);
    return description.add("<Instance of '$name'>");
  }

  @override
  bool matches(final Object? item, final Map<dynamic, dynamic> matchState) => item is T;

  @override
  Description describeMismatch(
    final dynamic item,
    final Description mismatchDescription,
    final Map<dynamic, dynamic> matchState,
    final bool verbose,
  ) {
    final String name = _stripDynamic(T);
    return mismatchDescription.add("is not an instance of '$name'");
  }
}

String _stripDynamic(final Type type) =>
    type.toString().replaceAll(_dart2DynamicArgs, '');
final RegExp _dart2DynamicArgs = RegExp('<dynamic(, dynamic)*>');
