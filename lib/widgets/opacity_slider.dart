import 'package:flutter/material.dart';
import 'package:overmaps/models/stacked_maps_model.dart';

class OpacitySlider extends Slider {
  OpacitySlider(
    StackedMapsModel mapsModel,
    BuildContext context,
    void Function(double)? onChanged, {
    super.key,
  }) : super(
          value: mapsModel.opacity,
          thumbColor: Theme.of(context).colorScheme.inversePrimary,
          activeColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: Theme.of(context).colorScheme.secondary,
          label: (mapsModel.opacity * 200 - 100).round().abs().toString(),
          max: 1.0,
          divisions: 100,
          onChanged: onChanged,
        );
}
