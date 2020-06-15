typedef FcBuilderFunc<S> = S Function();

typedef FcBuilderFuncAsync<S> = Future<S> Function();

class FcBuilder<S> {
  bool isSingleton;
  FcBuilderFunc builderFunc;
  S dependency;
  bool permanent = false;

  FcBuilder(this.isSingleton, this.builderFunc, this.permanent);

  S getSependency() {
    if (isSingleton) {
      if (dependency == null) {
        dependency = builderFunc() as S;
      }
      return dependency;
    } else {
      return builderFunc() as S;
    }
  }
}
