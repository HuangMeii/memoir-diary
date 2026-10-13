import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../widgets/weather_card.dart';

/// Weather utility: the forecast plus the saved location.
class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  final _lat = TextEditingController();
  final _lon = TextEditingController();
  final _name = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _lat.dispose();
    _lon.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final lat = double.tryParse(_lat.text.trim());
    final lon = double.tryParse(_lon.text.trim());
    if (lat == null || lon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập vĩ độ và kinh độ hợp lệ')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final name = _name.text.trim();
      await ref.read(weatherRepositoryProvider).setLocation(
            lat: lat,
            lon: lon,
            name: name.isEmpty ? null : name,
          );
      ref.invalidate(weatherProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu vị trí')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weather = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thời tiết'),
        actions: [
          IconButton(
            tooltip: 'Tải lại',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(weatherProvider),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          weather.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Không lấy được dữ liệu thời tiết.\n$error',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ),
            data: (forecast) => WeatherForecastView(forecast: forecast),
          ),
          const SizedBox(height: 24),
          Text('Vị trí', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Mặc định Hà Nội (21.0285, 105.8542).',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _lat,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Vĩ độ',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _lon,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Kinh độ',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: 'Tên hiển thị (tuỳ chọn)',
              hintText: 'Ví dụ: Hà Nội',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.place_outlined),
            label: const Text('Lưu vị trí'),
          ),
        ],
      ),
    );
  }
}
