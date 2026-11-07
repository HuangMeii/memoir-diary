import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth_provider.dart';
import '../../data/dicho_shopping.dart';
import '../../data/dicho_storage.dart';
import '../../data/providers.dart';
import '../dicho/dicho_chrome.dart';
import '../dicho/dicho_shopping_card.dart';
import '../dicho/dicho_stores_card.dart';
import '../home/home_scale.dart';
import '../tokens.dart';
import '../widgets/app_header.dart';
import '../widgets/text_prompt_dialog.dart';

/// Width of the "Đi chợ thông minh" web frame.
///
/// Nguồn thiết kế: `ui-figma/dicho/memoir_i_ch_th_ng_minh_y_chu_i_si_u_th`
/// (`max-w-7xl` with 32 px gutters).
const double kDichoDesignWidth = 1280;

/// Content width inside the frame's gutters.
const double kDichoContentWidth = 1208;

/// Gap of the design's 12-column grid (`gap-6`).
const double kDichoColumnGap = MemoirSpace.s6;

/// Breakpoint where the design switches to its 7 / 5 split (`lg`).
const double kDichoTwoColumnMinWidth = 1024;

/// "Đi chợ thông minh": basket, budget and the chains to compare.
///
/// DC-01 chrome + DC-02 basket + DC-03 store picker, all backed by the local
/// [dichoProvider]. The comparison matrix, shopping routes, save-to-journal
/// and handheld mode are the remaining tasks in `docs/dicho/README.md`.
class DichoScreen extends ConsumerStatefulWidget {
  const DichoScreen({super.key});

  @override
  ConsumerState<DichoScreen> createState() => _DichoScreenState();
}

class _DichoScreenState extends ConsumerState<DichoScreen> {
  Future<void> _createList() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const TextPromptDialog(
        title: 'Danh sách mới',
        hintText: 'Tên danh sách, vd: Đi chợ cuối tuần',
        confirmLabel: 'Tạo',
      ),
    );
    if (name == null || name.trim().isEmpty) return;
    ref.read(dichoProvider.notifier).createList(name: name);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    ref.watch(authReadyProvider);
    final displayName = auth.user?['display_name'] as String?;
    final state = ref.watch(dichoProvider);
    final notifier = ref.read(dichoProvider.notifier);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scale = homeScaleFor(
            constraints.maxWidth,
            designWidth: kDichoDesignWidth,
          );
          final textScale = homeTextScaleFor(
            constraints.maxWidth,
            designWidth: kDichoDesignWidth,
          );
          final twoColumn = constraints.maxWidth >= kDichoTwoColumnMinWidth;
          final media = MediaQuery.of(context);

          return MediaQuery(
            data: media.copyWith(
              textScaler: textScale == 1
                  ? media.textScaler
                  : HomeTextScaler(base: media.textScaler, factor: textScale),
            ),
            child: HomeScale(
              factor: scale,
              textFactor: textScale,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    AppHeader(
                      date: DateTime.now(),
                      initials: initialsOf(displayName),
                      name: displayName,
                      onLogout: () => ref.read(authProvider.notifier).logout(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: MemoirSpace.s4 * scale,
                          vertical: MemoirSpace.s6 * scale,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: kDichoContentWidth,
                            ),
                            child: _content(context, state, notifier,
                                twoColumn: twoColumn, scale: scale),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _content(
    BuildContext context,
    DichoState state,
    DichoNotifier notifier, {
    required bool twoColumn,
    required double scale,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DichoBreadcrumb(onHome: () => Navigator.of(context).maybePop()),
        SizedBox(height: MemoirSpace.s3 * scale),
        DichoPageHeader(
          lists: state.lists,
          selectedListId: state.selectedListId,
          onSelectList: notifier.selectList,
          onCreateList: _createList,
        ),
        SizedBox(height: MemoirSpace.s4 * scale),
        const DichoNoticeBanner(),
        SizedBox(height: MemoirSpace.s5 * scale),
        if (twoColumn)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: DichoShoppingCard(state: state, notifier: notifier),
              ),
              const SizedBox(width: kDichoColumnGap),
              Expanded(
                flex: 5,
                child: DichoStoresCard(state: state, notifier: notifier),
              ),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DichoShoppingCard(state: state, notifier: notifier),
              const SizedBox(height: kDichoColumnGap),
              DichoStoresCard(state: state, notifier: notifier),
            ],
          ),
        SizedBox(height: MemoirSpace.s8 * scale),
      ],
    );
  }
}
