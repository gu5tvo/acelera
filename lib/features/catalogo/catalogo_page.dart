import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/bike_image.dart';
import '../../core/widgets/common.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import 'bike_detail_page.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  static const _categories = [
    'Todas',
    'Street',
    'Esportiva',
    'Adventure',
    'Custom',
  ];

  int _category = 0;
  String _query = '';

  List<Bike> get _bikes {
    final query = _query.trim().toLowerCase();
    return MockData.bikes
        .where((bike) {
          final matchesCategory =
              _category == 0 || bike.category == _categories[_category];
          final matchesQuery =
              query.isEmpty ||
              bike.name.toLowerCase().contains(query) ||
              bike.brand.toLowerCase().contains(query);
          return matchesCategory && matchesQuery;
        })
        .toList(growable: false);
  }

  void _open(Bike bike, String heroTag) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BikeDetailPage(bike: bike, heroTag: heroTag),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bikes = _bikes;
    final showFeatured = _category == 0 && _query.trim().isEmpty;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Center(
      child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              WhatsAppSliverAppBar(
                title: 'Catálogo',
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    tooltip: 'Favoritos',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    tooltip: 'Mais',
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AppSearchField(
                    hint: 'Buscar moto ou marca',
                    onChanged: (value) => setState(() => _query = value),
                    onFilter: () {},
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, i) => AppFilterChip(
                        label: _categories[i],
                        selected: _category == i,
                        onTap: () => setState(() => _category = i),
                      ),
                    ),
                  ),
                ),
              ),
              if (showFeatured)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                    child: _FeaturedCard(
                      bike: MockData.featuredBike,
                      onTap: () => _open(
                        MockData.featuredBike,
                        'featured-${MockData.featuredBike.id}',
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
                  child: SectionHeader(
                    title: showFeatured ? 'Todas as motos' : 'Resultados',
                    count: bikes.length,
                  ),
                ),
              ),
              if (bikes.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyCatalog(),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 130 + bottomInset),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 215,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.71,
                        ),
                    itemCount: bikes.length,
                    itemBuilder: (context, i) {
                      final bike = bikes[i];
                      return _BikeCard(
                        bike: bike,
                        onTap: () => _open(bike, 'bike-${bike.id}'),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.bike, required this.onTap});

  final Bike bike;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 194,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'featured-${bike.id}',
                  child: BikeImage(
                    asset: bike.image,
                    fit: BoxFit.cover,
                    cacheWidth: 900,
                    alignment: Alignment(0, -0.2),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x0D0A1224),
                        Color(0x660A1224),
                        Color(0xE60A1224),
                      ],
                      stops: [0, 0.45, 1],
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lime,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'DESTAQUE DA SEMANA',
                      style: jk(
                        9,
                        800,
                        color: AppColors.ink,
                        letterSpacing: 0.5,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 14,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${bike.brand} · ${bike.category}',
                              style: jk(
                                10.5,
                                600,
                                color: Colors.white.withValues(alpha: 0.72),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              bike.name,
                              style: jk(
                                21,
                                800,
                                color: Colors.white,
                                height: 1.1,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  brl(bike.price),
                                  style: jk(
                                    14,
                                    800,
                                    color: Colors.white,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'ou ${brl(bike.monthly)}/mês',
                                  style: jk(
                                    10.5,
                                    500,
                                    color: Colors.white.withValues(alpha: 0.66),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: AppColors.lime,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.ink,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BikeCard extends StatelessWidget {
  const _BikeCard({required this.bike, required this.onTap});

  final Bike bike;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'bike-${bike.id}',
                        child: BikeImage(
                          asset: bike.image,
                          fit: BoxFit.cover,
                          cacheWidth: 500,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lime,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            bike.badge,
                            style: jk(
                              9,
                              800,
                              color: AppColors.ink,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_border_rounded,
                            size: 15,
                            color: AppColors.inkSoft,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(11, 10, 11, 11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bike.name,
                        style: AppText.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${bike.year} · ${bike.km}',
                        style: AppText.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 7),
                      Text(
                        brl(bike.price),
                        style: jk(15, 800, height: 1.1, letterSpacing: -0.4),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ou ${brl(bike.monthly)}/mês',
                        style: jk(
                          10,
                          600,
                          color: AppColors.primary,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyCatalog extends StatelessWidget {
  const _EmptyCatalog();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 140),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.two_wheeler_rounded,
              color: AppColors.inkMuted,
              size: 30,
            ),
          ),
          const SizedBox(height: 14),
          Text('Nenhuma moto encontrada', style: AppText.h3),
          const SizedBox(height: 4),
          Text(
            'Tente outra categoria ou termo de busca.',
            style: AppText.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
