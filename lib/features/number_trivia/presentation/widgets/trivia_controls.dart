import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({Key? key}) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String inputStr = '';
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          onChanged: (v) {
            inputStr = v;
          },
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            hintText: 'Input a number',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => dispatchConcrete(),
        ),
        const SizedBox(height: 5,),
        Row(
          children: [
            Expanded(
              child: RaisedButton(
                child: const Text('Search'),
                textTheme: ButtonTextTheme.primary,
                color: Theme.of(context).colorScheme.secondary,
                onPressed: dispatchConcrete,
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: RaisedButton(
                child: const Text('Get random trivia'),
                onPressed: dispatchRandom,
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputStr));
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForRandomNumber());
  }

}