import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:leancode_pipe/leancode_pipe.dart';
import 'package:leancode_pipe_example/screen_cubit.dart';
import 'package:provider/provider.dart';

class LeancodePipeDraftApp extends StatelessWidget {
  const LeancodePipeDraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bidController = useTextEditingController();

    return Provider(
      create: (context) => PipeClient(
        pipeUrl: ScreenCubit.leanPipeExampleUrl,
        tokenFactory: () async => 'token',
      ),
      dispose: (context, value) => value.dispose(),
      child: BlocProvider(
        create: (context) => ScreenCubit(context.read()),
        child: Scaffold(
          appBar: AppBar(title: const Text('Leancode Pipe Draft')),
          body: BlocBuilder<ScreenCubit, DraftScreenState>(
            builder: (context, state) => SafeArea(
              minimum:
                  const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            state.map(
                              connected: (state) => state.data,
                              disconnected: (state) =>
                                  'Disconnected. Error: ${state.error}. Connecting: ${state.connecting}',
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      const Divider(height: 32, thickness: 2),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: bidController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              final value = int.tryParse(bidController.text);
                              if (value != null) {
                                context.read<ScreenCubit>().placeBid(value);
                              }
                            },
                            child: const Text('Place bid'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: context.read<ScreenCubit>().buy,
                            child: const Text('Buy'),
                          ),
                        ],
                      ),
                      const Divider(thickness: 2, height: 24),
                      Row(
                        children: [
                          const Text('Authorized:'),
                          const SizedBox(width: 16),
                          Checkbox(
                            value: state.authorized,
                            onChanged: (_) => context
                                .read<ScreenCubit>()
                                .switchAuthorization(),
                          ),
                        ],
                      ),
                      const Divider(thickness: 2, height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: context.read<ScreenCubit>().subscribe,
                              child: const Text('Subscribe'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  context.read<ScreenCubit>().unsubscribe,
                              child: const Text('Unsubscribe'),
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 2, height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: context.read<ScreenCubit>().connect,
                              child: const Text('Connect'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: context.read<ScreenCubit>().disconnect,
                              child: const Text('Disconnect'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (state is DraftScreenDisconnected && state.connecting)
                    const Positioned.fill(
                      child: IgnorePointer(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
