import 'package:flutter/material.dart';
import 'package:overmaps/models/stacked_maps_model.dart';

class BearingSlider extends Slider {
  BearingSlider(
    StackedMapsModel mapsModel,
    BuildContext context,
    void Function(double)? onChanged, {
    super.key,
  }) : super(
          value: mapsModel.bearing,
          thumbColor: Theme.of(context).colorScheme.inversePrimary,
          activeColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: Theme.of(context).colorScheme.secondary,
          label: mapsModel.bearing.round().abs().toString(),
          min: -180.0,
          max: 180.0,
          divisions: 360,
          onChanged: onChanged,
        );
}
