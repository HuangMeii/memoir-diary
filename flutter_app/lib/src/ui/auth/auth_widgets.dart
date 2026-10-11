import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme.dart';
import '../tokens.dart';

/// Assets exported from the Figma design.
const brandMarkAsset = 'assets/illustrations/brand-mark.svg';
const loginIllustrationAsset = 'assets/illustrations/illustration-login.svg';

/// Brand lockup: the vector mark next to the wordmark set in Lora.
class BrandLockup extends StatelessWidget {
  const BrandLockup({super.key, this.markSize = 36});

  final double markSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(brandMarkAsset, width: markSize, height: markSize),
        const SizedBox(width: MemoirSpace.s3),
        Text(
          'Memoir',
          style: TextStyle(
            fontFamily: serifFamily,
            fontSize: MemoirType.brand,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

/// The editorial column: illustration, headline, blurb and overline.
class EditorialMoment extends StatelessWidget {
  const EditorialMoment({super.key, this.showIllustration = true});

  final bool showIllustration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final serif = TextStyle(fontFamily: serifFamily, color: theme.colorScheme.onSurface);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIllustration) ...[
          SvgPicture.asset(loginIllustrationAsset, width: 340, height: 300),
          const SizedBox(height: MemoirSpace.s6),
        ],
        Text('Mỗi ngày một trang.\nMỗi trang một chút mình.',
            style: serif.copyWith(fontSize: MemoirType.headingEditorial, height: 1.3)),
        const SizedBox(height: MemoirSpace.s3),
        Text(
          'Lưu lại những điều nhỏ bé hôm nay, để một ngày nhìn lại và thấy mình đã lớn lên.',
          style: TextStyle(
            fontSize: MemoirType.bodyEditorial,
            height: 1.6,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: MemoirSpace.s5),
        Text(
          'VIẾT CHO MÌNH. GIỮ CHO MÌNH.',
          style: TextStyle(
            fontSize: MemoirType.overline2Editorial,
            letterSpacing: 3,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

/// Inline error shown for the invalid-credentials / network-error states.
class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final background =
        dark ? MemoirColorsDark.feedbackErrorBackground : MemoirColorsLight.feedbackErrorBackground;
    final foreground = dark ? MemoirColorsDark.feedbackError : MemoirColorsLight.feedbackError;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(MemoirSpace.s3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(MemoirRadius.feedback),
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: MemoirType.feedback, color: foreground),
      ),
    );
  }
}

/// Page shell: brand on top, editorial + form side by side on wide screens,
/// stacked on phones — mirroring the mobile and web frames in Figma.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.card});

  final Widget card;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;
            final horizontal = wide ? MemoirSpace.s12 : MemoirSpace.s6;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontal,
                vertical: MemoirSpace.s8,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BrandLockup(),
                      const SizedBox(height: MemoirSpace.s3),
                      Text(
                        'Nhật ký mỗi ngày, nhìn lại chính mình',
                        style: TextStyle(
                          fontSize: MemoirType.bodyMeta,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: wide ? MemoirSpace.s14 : MemoirSpace.s10),
                      if (wide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(child: EditorialMoment()),
                            const SizedBox(width: MemoirSpace.s14),
                            SizedBox(width: 400, child: card),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const EditorialMoment(showIllustration: false),
                            const SizedBox(height: MemoirSpace.s10),
                            card,
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
