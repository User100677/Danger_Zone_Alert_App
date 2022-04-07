import 'package:flutter/cupertino.dart';

// Design Pattern
// Stateless Widget
abstract class StatelessView<T1> extends StatelessWidget {
  final T1 widget;
  const StatelessView(this.widget, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context);
}

// Stateful Widget
abstract class WidgetView<T1, T2> extends StatelessWidget {
  final T2 state;
  T1 get widget => (state as State).widget as T1;

  const WidgetView(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context);
}

// Example usage: Stateful widgets
// class ExampleScreen extends StatefulWidget {
//   const ExampleScreen({Key? key}) : super(key: key);
//
//   @override
//   _ExampleScreenController createState() => _ExampleScreenController();
// }
//
// class _ExampleScreenController extends State<ExampleScreen> {
//   @override
//   Widget build(BuildContext context) => _ExampleScreenView(this);
// }
//
// class _ExampleScreenView
//     extends WidgetView<ExampleScreen, _ExampleScreenController> {
//   const _ExampleScreenView(_ExampleScreenController state) : super(state);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
