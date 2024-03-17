import 'package:flutter/material.dart';
import 'package:overmaps/models/stacked_maps_model.dart';
import 'package:vertical_slider/vertical_slider.dart';

class TiltSlider extends VerticalSlider {
  TiltSlider(
    StackedMapsModel mapsModel,
    BuildContext context,
    void Function(double) onChanged, {
    super.key,
  }) : super(
          value: mapsModel.tilt,
          min: StackedMapsModel.minTilt,
          max: StackedMapsModel.maxTilt,
          thumbColor: Theme.of(context).colorScheme.inversePrimary,
          activeColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: Theme.of(context).colorScheme.secondary,
          label: (((mapsModel.tilt) * 100) / StackedMapsModel.maxTilt)
              .round()
              .toString(),
          divisions: StackedMapsModel.maxTilt.toInt() * 100,
          onChanged: onChanged,
        );
}
