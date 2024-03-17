import 'package:flutter/material.dart';
import 'package:overmaps/models/stacked_maps_model.dart';
import 'package:vertical_slider/vertical_slider.dart';

class ZoomSlider extends VerticalSlider {
  ZoomSlider(
    StackedMapsModel mapsModel,
    BuildContext context,
    void Function(double) onChanged, {
    super.key,
  }) : super(
          value: mapsModel.zoom,
          min: StackedMapsModel.minZoom,
          max: StackedMapsModel.maxZoom,
          thumbColor: Theme.of(context).colorScheme.inversePrimary,
          activeColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: Theme.of(context).colorScheme.secondary,
          label: (((mapsModel.zoom) * 100) / StackedMapsModel.maxZoom)
              .round()
              .toString(),
          divisions: StackedMapsModel.maxZoom.toInt() * 100,
          onChanged: onChanged,
        );
}
