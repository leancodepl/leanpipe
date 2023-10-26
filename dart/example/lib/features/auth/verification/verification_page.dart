import 'package:app/common/colors.dart';
import 'package:app/common/widgets/app_design_system.dart';
import 'package:app/common/widgets/app_pin_code_input.dart';
import 'package:app/features/auth/verification/verification_cubit.dart';
import 'package:app/navigation/routes.dart';
import 'package:app/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

const verificationCodeLength = 6;

class VerifyCodePage extends Page<void> {
  VerifyCodePage({this.email, this.flowId, this.code})
      : super(key: ValueKey(code));

  final String? email;
  final String? flowId;
  final String? code;

  @override
  Route<void> createRoute(BuildContext context) => VerifyCodeRoute(
        page: this,
        email: email,
        flowId: flowId,
      );
}

class VerifyCodeRoute extends MaterialPageRoute<void> {
  VerifyCodeRoute({
    VerifyCodePage? page,
    String? email,
    String? flowId,
    String? code,
  }) : super(
          settings: page,
          builder: (context) => VerificationPage(
            email: email,
            flowId: flowId,
            code: code,
          ),
        );
}

class VerificationPage extends HookWidget {
  const VerificationPage({
    super.key,
    required this.email,
    required this.flowId,
    required this.code,
  });

  final String? email;
  final String? flowId;
  final String? code;

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);

    final verificationCubit = useBloc(
      () => VerificationCubit(
        flowId: flowId,
        email: email,
        kratosClient: context.read<KratosClient>(),
      )..init(),
    );

    return Scaffold(
      appBar: AppBar(
        title: AppText(s.verification_page_title),
      ),
      body: VerificationBody(
        verificationCubit: verificationCubit,
      ),
    );
  }
}

class VerificationBody extends HookWidget {
  const VerificationBody({
    super.key,
    required this.verificationCubit,
  });

  final VerificationCubit verificationCubit;

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);
    final colors = context.colors;

    final pinController = useMemoized(
      AppPinCodeInputController.new,
      [],
    );

    useEffect(() => pinController.dispose, [pinController]);

    return BlocConsumer(
      bloc: verificationCubit,
      listener: (context, state) {
        if (state is VerificationSuccess) {
          final snackBar = SnackBar(
            backgroundColor: colors.backgroundSuccessSecondary,
            content: AppText(s.success_verification),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          context.go(AuthRoute<void>().location);
        } else if (state is VerificationError) {
          final snackBar = SnackBar(
            backgroundColor: colors.backgroundDangerSecondary,
            content: AppText(s.error_verification),
          );
          pinController.clear();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Visibility(
              visible: switch (state) {
                VerificationInitial() => state.inProgress,
                _ => false
              },
              child: Container(
                color: colors.backgroundDefaultSecondary,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            AppPinCodeInput(
              fieldsCount: verificationCodeLength,
              title: s.enter_code_email,
              onComplete: (code) => verificationCubit.verify(code: code),
              controller: pinController,
            ),
          ],
        );
      },
    );
  }
}
