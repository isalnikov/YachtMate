import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/onboarding_prefs.dart';
import '../../core/theme/cw_theme_extensions.dart';
import '../../core/theme/cw_tokens.dart';
import '../../core/theme/cw_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_button.dart';
import '../../widgets/cw_chip.dart';
import 'onboarding_page.dart';

/// First-run onboarding: Welcome → Permissions → Experience → Region.
class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  static const _pageCount = 4;

  final _pageController = PageController();
  int _pageIndex = 0;
  String? _experience;
  String? _region;
  bool _locationRequested = false;
  bool _notificationRequested = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _requestLocation() async {
    var p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
    }
    if (!mounted) return;
    setState(() {
      _locationRequested = true;
    });
  }

  Future<void> _requestNotifications() async {
    await Permission.notification.request();
    if (!mounted) return;
    setState(() {
      _notificationRequested = true;
    });
  }

  Future<void> _finish() async {
    await ref.read(onboardingCompleteProvider.notifier).complete(
          experience: _experience,
          region: _region,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final colors = context.cwColors;
    final isLastPage = _pageIndex == _pageCount - 1;
    final canAdvance = switch (_pageIndex) {
      2 => _experience != null,
      3 => _region != null,
      _ => true,
    };

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _pageIndex = i),
              children: [
                _WelcomeHeroPage(l10n: l10n),
                OnboardingPage(
                  title: l10n.onboardingPermissionsTitle,
                  subtitle: l10n.onboardingPermissionsBody,
                  child: _PermissionsContent(
                    l10n: l10n,
                    locationRequested: _locationRequested,
                    notificationRequested: _notificationRequested,
                    onLocation: _requestLocation,
                    onNotifications: _requestNotifications,
                  ),
                ),
                OnboardingPage(
                  title: l10n.onboardingExperienceTitle,
                  subtitle: l10n.onboardingExperienceBody,
                  child: _ExperienceChips(
                    l10n: l10n,
                    selected: _experience,
                    onSelected: (v) => setState(() => _experience = v),
                  ),
                ),
                OnboardingPage(
                  title: l10n.onboardingRegionTitle,
                  subtitle: l10n.onboardingRegionBody,
                  child: _RegionPicker(
                    l10n: l10n,
                    selected: _region,
                    onSelected: (v) => setState(() => _region = v),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              CwSpacing.l,
              CwSpacing.s,
              CwSpacing.l,
              CwSpacing.l,
            ),
            child: Column(
              children: [
                _PageDots(
                  count: _pageCount,
                  index: _pageIndex,
                  activeColor: colors.accentTeal,
                  inactiveColor: colors.textMuted.withValues(alpha: 0.35),
                ),
                const SizedBox(height: CwSpacing.l),
                Row(
                  children: [
                    if (_pageIndex > 0)
                      Expanded(
                        child: CwButton(
                          key: const Key('onboarding_back'),
                          label: l10n.onboardingBack,
                          variant: CwButtonVariant.secondary,
                          onPressed: () => _goToPage(_pageIndex - 1),
                        ),
                      ),
                    if (_pageIndex > 0) const SizedBox(width: CwSpacing.m),
                    Expanded(
                      flex: _pageIndex > 0 ? 1 : 2,
                      child: CwButton(
                        key: Key(
                          isLastPage
                              ? 'onboarding_get_started'
                              : 'onboarding_next',
                        ),
                        label: isLastPage
                            ? l10n.onboardingGetStarted
                            : l10n.onboardingNext,
                        onPressed: canAdvance
                            ? () async {
                                if (isLastPage) {
                                  await _finish();
                                } else {
                                  _goToPage(_pageIndex + 1);
                                }
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Navily-style full-bleed welcome hero (Step 08).
class _WelcomeHeroPage extends StatelessWidget {
  const _WelcomeHeroPage({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final size = MediaQuery.sizeOf(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.accentTeal.withValues(alpha: 0.45),
                colors.deckBlue,
                const Color(0xFF061018),
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
          child: CustomPaint(
            painter: _HeroWavePainter(
              water: colors.accentTeal.withValues(alpha: 0.18),
              hill: colors.accentOrange.withValues(alpha: 0.22),
            ),
            size: Size(size.width, size.height),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.15),
                Colors.black.withValues(alpha: 0.55),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(CwSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 3),
                Icon(
                  Icons.anchor,
                  size: 56,
                  color: colors.textPrimary,
                  semanticLabel: l10n.onboardingWelcomeTagline,
                ),
                const SizedBox(height: CwSpacing.l),
                Text(
                  l10n.onboardingWelcomeTagline,
                  style: CwTypography.caption(
                    color: colors.textPrimary.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: CwSpacing.s),
                Text(
                  l10n.onboardingWelcomeTitle,
                  style: CwTypography.display(color: colors.textPrimary),
                ),
                const SizedBox(height: CwSpacing.m),
                Text(
                  l10n.onboardingWelcomeSubtitle,
                  style: CwTypography.body(
                    color: colors.textPrimary.withValues(alpha: 0.9),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroWavePainter extends CustomPainter {
  _HeroWavePainter({required this.water, required this.hill});

  final Color water;
  final Color hill;

  @override
  void paint(Canvas canvas, Size size) {
    final hillPaint = Paint()..color = hill;
    final hillPath = Path()
      ..moveTo(0, size.height * 0.42)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.28,
        size.width * 0.65,
        size.height * 0.38,
      )
      ..quadraticBezierTo(
        size.width * 0.9,
        size.height * 0.48,
        size.width,
        size.height * 0.34,
      )
      ..lineTo(size.width, size.height * 0.55)
      ..lineTo(0, size.height * 0.55)
      ..close();
    canvas.drawPath(hillPath, hillPaint);

    final waterPaint = Paint()..color = water;
    final wavePath = Path()
      ..moveTo(0, size.height * 0.58)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.52,
        size.width * 0.5,
        size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.68,
        size.width,
        size.height * 0.56,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(wavePath, waterPaint);
  }

  @override
  bool shouldRepaint(covariant _HeroWavePainter oldDelegate) => false;
}

class _PermissionsContent extends StatelessWidget {
  const _PermissionsContent({
    required this.l10n,
    required this.locationRequested,
    required this.notificationRequested,
    required this.onLocation,
    required this.onNotifications,
  });

  final AppLocalizations l10n;
  final bool locationRequested;
  final bool notificationRequested;
  final VoidCallback onLocation;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;

    return ListView(
      children: [
        _PermissionTile(
          icon: Icons.location_on_outlined,
          title: l10n.onboardingLocationTitle,
          granted: locationRequested,
          buttonLabel: l10n.onboardingLocationButton,
          buttonKey: const Key('onboarding_location'),
          onRequest: onLocation,
          colors: colors,
        ),
        const SizedBox(height: CwSpacing.m),
        _PermissionTile(
          icon: Icons.notifications_outlined,
          title: l10n.onboardingNotificationTitle,
          granted: notificationRequested,
          buttonLabel: l10n.onboardingNotificationButton,
          buttonKey: const Key('onboarding_notifications'),
          onRequest: onNotifications,
          colors: colors,
        ),
      ],
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.granted,
    required this.buttonLabel,
    required this.buttonKey,
    required this.onRequest,
    required this.colors,
  });

  final IconData icon;
  final String title;
  final bool granted;
  final String buttonLabel;
  final Key buttonKey;
  final VoidCallback onRequest;
  final CwColors colors;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.panelBlue,
      borderRadius: BorderRadius.circular(CwRadius.md),
      child: Padding(
        padding: const EdgeInsets.all(CwSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colors.accentTeal),
                const SizedBox(width: CwSpacing.m),
                Expanded(
                  child: Text(
                    title,
                    style: CwTypography.h2(color: colors.textPrimary),
                  ),
                ),
                if (granted)
                  Icon(Icons.check_circle, color: colors.safe, size: 22),
              ],
            ),
            const SizedBox(height: CwSpacing.m),
            CwButton(
              key: buttonKey,
              label: buttonLabel,
              variant: CwButtonVariant.secondary,
              expand: false,
              onPressed: granted ? null : onRequest,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperienceChips extends StatelessWidget {
  const _ExperienceChips({
    required this.l10n,
    required this.selected,
    required this.onSelected,
  });

  final AppLocalizations l10n;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final options = [
      (l10n.onboardingExperienceBeginner, 'beginner'),
      (l10n.onboardingExperienceCruiser, 'cruiser'),
      (l10n.onboardingExperienceRacer, 'racer'),
    ];

    return Wrap(
      spacing: CwSpacing.s,
      runSpacing: CwSpacing.s,
      children: [
        for (final (label, value) in options)
          CwChip(
            key: Key('onboarding_experience_$value'),
            label: label,
            selected: selected == value,
            onSelected: (_) => onSelected(value),
          ),
      ],
    );
  }
}

class _RegionPicker extends StatelessWidget {
  const _RegionPicker({
    required this.l10n,
    required this.selected,
    required this.onSelected,
  });

  final AppLocalizations l10n;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final options = [
      (l10n.onboardingRegionMediterranean, 'mediterranean', Icons.wb_sunny_outlined),
      (l10n.onboardingRegionCaribbean, 'caribbean', Icons.beach_access_outlined),
      (l10n.onboardingRegionOther, 'other', Icons.public_outlined),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (label, value, icon) in options) ...[
          _RegionOptionTile(
            key: Key('onboarding_region_$value'),
            label: label,
            icon: icon,
            selected: selected == value,
            colors: colors,
            onTap: () => onSelected(value),
          ),
          const SizedBox(height: CwSpacing.s),
        ],
      ],
    );
  }
}

class _RegionOptionTile extends StatelessWidget {
  const _RegionOptionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final CwColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected
            ? colors.accentTeal.withValues(alpha: 0.18)
            : colors.panelBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CwRadius.md),
          side: BorderSide(
            color: selected
                ? colors.accentTeal
                : colors.accentTeal.withValues(alpha: 0.2),
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: CwSpacing.m,
              vertical: CwSpacing.m,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selected ? colors.accentTeal : colors.textMuted,
                ),
                const SizedBox(width: CwSpacing.m),
                Expanded(
                  child: Text(
                    label,
                    style: CwTypography.body(
                      color: selected ? colors.textPrimary : colors.textMuted,
                    ),
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle, color: colors.accentTeal, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({
    required this.count,
    required this.index,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int count;
  final int index;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(CwRadius.full),
          ),
        );
      }),
    );
  }
}
