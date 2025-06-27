import 'package:flutter/material.dart';
import 'package:scanly_test/src/app/app_bloc/app_bloc.dart';
import 'package:scanly_test/src/app/design_system/design_system.dart';

import 'package:scanly_test/src/app/navigation/navigation.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _canNavigate = false;
  EntryState? _bufferedState;
  late final ValueNotifier<bool> _canPop;
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _canPop = ValueNotifier(false);
    _listener = AppLifecycleListener(
      onResume: () {
        context.read<PopHandlerCubit>().updateState();
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EntryCubit>().check();
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // In case the state was already emitted before listener mounted
  //   final currentState = context.read<EntryCubit>().state;
  //   _bufferedState = currentState;
  //   _maybeNavigate('didChangeDependencies');
  // }

  void _maybeNavigate() {
    if (!_canNavigate || _bufferedState == null) return;

    _bufferedState!.whenOrNull(
      notIntroduced: () {
        GetAppNavigator.entryNavigator().navigateOnboardingPage(context);
        _canNavigate = false;
      },
      introduced: (openRatePage) {
        _canNavigate = false;
        if (openRatePage) {
          GetAppNavigator.entryNavigator().navigateRatePage(context);
        } else {
          GetAppNavigator.mainNavigator().navigateToMainPage(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PopHandlerCubit, PopHandlerState>(
          listener: (context, state) {
            _canPop.value = state.maybeWhen(
              popRoute: () => true,
              orElse: () => false,
            );
          },
        ),
        BlocListener<EntryCubit, EntryState>(
          bloc: context.read<EntryCubit>(),
          listener: (context, state) {
            _bufferedState = state;
            _maybeNavigate();
          },
        ),
      ],
      child: PopScope(
        canPop: _canPop.value,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            context.read<PopHandlerCubit>().handle();
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: REdgeInsets.all(16),
              child: Center(
                child: DownToUp(
                  withPosition: false,
                  delayFactor: 1,
                  child: AppAsset.logo.displayImage(width: 250),
                  onFinish: () {
                    Future.delayed(const Duration(milliseconds: 200), () {
                      _canNavigate = true;
                      _maybeNavigate();
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    _canPop.dispose();
    super.dispose();
  }
}
