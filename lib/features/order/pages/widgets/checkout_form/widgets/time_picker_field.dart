import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../presentation/cubits/chekout_cubit/chekout_cubit.dart';

class TimePickerField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CheckoutCubit>().state;
    final label = state.scheduledTime == null
        ? 'Выбрать время'
        : DateFormat('dd.MM.yyyy HH:mm').format(state.scheduledTime!);

    return OutlinedButton.icon(
      icon: const Icon(Icons.access_time),
      label: Text(label),
      onPressed: () async {
        final now = DateTime.now();
        final date = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: now,
          lastDate: now.add(const Duration(days: 30)),
        );
        if (date == null || !context.mounted) return;
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time == null) return;
        final dt = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        context.read<CheckoutCubit>().setScheduledTime(dt);
      },
    );
  }
}