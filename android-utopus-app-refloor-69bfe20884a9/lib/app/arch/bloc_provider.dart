import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class BlocBase{
  void dispose(){

    disposeBag.dispose();
  }
  CompositeSubscription disposeBag = CompositeSubscription();

}
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key? key,
    required this.child,
    required this.bloc,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    BlocProvider<T> provider = context.findAncestorWidgetOfExactType()!;
    return provider.bloc;
  }
}



class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void dispose() {
    print("Bloc provider disposed");

    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}