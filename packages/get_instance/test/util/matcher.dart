import 'package:test/test.dart';

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

class _FunctionMatcher<T> extends CustomMatcher {
  final dynamic Function(T value) _feature;

  _FunctionMatcher(String name, this._feature, matcher)
      : super('`$name`:', '`$name`', matcher);

  @override
  Object featureValueOf(covariant T actual) => _feature(actual);
}

class HavingMatcher<T> implements TypeMatcher<T> {
  final TypeMatcher<T> _parent;
  final List<_FunctionMatcher<T>> _functionMatchers;

  HavingMatcher(TypeMatcher<T> parent, String description,
      Object Function(T) feature, dynamic matcher,
      [Iterable<_FunctionMatcher<T>> existing])
      : _parent = parent,
        _functionMatchers = [
          ...?existing,
          _FunctionMatcher<T>(description, feature, matcher)
        ];

  @override
  TypeMatcher<T> having(
          Object Function(T) feature, String description, dynamic matcher) =>
      HavingMatcher(_parent, description, feature, matcher, _functionMatchers);

  @override
  bool matches(dynamic item, Map matchState) {
    for (var matcher in <Matcher>[_parent].followedBy(_functionMatchers)) {
      if (!matcher.matches(item, matchState)) {
        addStateInfo(matchState, {'matcher': matcher});
        return false;
      }
    }
    return true;
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    var matcher = matchState['matcher'] as Matcher;
    matcher.describeMismatch(
        item, mismatchDescription, matchState['state'] as Map, verbose);
    return mismatchDescription;
  }

  @override
  Description describe(Description description) => description
      .add('')
      .addDescriptionOf(_parent)
      .add(' with ')
      .addAll('', ' and ', '', _functionMatchers);
}

class TypeMatcher<T> extends Matcher {
  const TypeMatcher();

  TypeMatcher<T> having(
          Object Function(T) feature, String description, dynamic matcher) =>
      HavingMatcher(this, description, feature, matcher);

  @override
  Description describe(Description description) {
    var name = _stripDynamic(T);
    return description.add("<Instance of '$name'>");
  }

  @override
  bool matches(Object item, Map matchState) => item is T;

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    var name = _stripDynamic(T);
    return mismatchDescription.add("is not an instance of '$name'");
  }
}

String _stripDynamic(Type type) =>
    type.toString().replaceAll(_dart2DynamicArgs, '');
final _dart2DynamicArgs = RegExp('<dynamic(, dynamic)*>');
