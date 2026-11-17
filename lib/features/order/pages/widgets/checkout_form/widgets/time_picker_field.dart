import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../presentation/cubits/chekout_cubit/chekout_cubit.dart';

class TimePickerField extends StatelessWidget {
  const TimePickerField({super.key, required this.fieldKey});
  final GlobalKey<FormFieldState<DateTime>> fieldKey;

  @override
  Widget build(BuildContext context) {
    final state = context
        .watch<CheckoutCubit>()
        .state;
    final label = state.scheduledTime == null
        ? 'Выбрать время'
        : DateFormat('dd.MM.yyyy HH:mm').format(state.scheduledTime!);

    return FormField<DateTime>(
      key: fieldKey,
      initialValue: state.scheduledTime,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null) return 'Выберите время';
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.access_time),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color:!field.hasError? const Color(0xFF000000):const Color(0xFFB3261E), // Цвет рамки
                ),
              ),
              onPressed: () async {
                final cubit = context.read<CheckoutCubit>();
                final today = DateUtils.dateOnly(DateTime.now());
                var selectedDay = cubit.state.scheduledTime == null
                    ? today
                    : DateUtils.dateOnly(cubit.state.scheduledTime!);

                showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.0),
                      ),
                    ),
                    builder: (sheetContext) {
                      return StatefulBuilder(
                        builder: (context, setSheetState) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Column(
                            //  mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height:82, //92,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    itemCount: 7,
                                    separatorBuilder: (_, _) =>
                                        const SizedBox(width: 8),
                                    itemBuilder: (context, index) {
                                      final day = today.add(
                                        Duration(days: index),
                                      );
                                      return _DayCard(
                                        date: day,
                                        selected: DateUtils.isSameDay(
                                          day,
                                          selectedDay,
                                        ),
                                        onTap: () {
                                          setSheetState(
                                            () => selectedDay = day,
                                          );
                                          final previous =
                                              cubit.state.scheduledTime;
                                          final time = previous != null
                                              ? TimeOfDay.fromDateTime(previous)
                                              : TimeOfDay.now();
                                          final dt = DateTime(
                                            day.year,
                                            day.month,
                                            day.day,
                                            time.hour,
                                            time.minute,
                                          );
                                          cubit.setScheduledTime(dt);
                                          field.didChange(dt);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    });
                /*final now = DateTime.now();
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
                field.didChange(dt);*/
              },
            ),
            (field.hasError)
                ? Padding(
              padding: const EdgeInsets.only(top: 6, left: 12),
              child: Text(
                field.errorText!,
                style: const TextStyle(
                  color: Color(0xFFB3261E) /*Colors.red[800]*/,
                  fontSize: 12,
                ),
              ),
            )
                : const SizedBox(height: 20),
          ],
        );
      },

    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.date,
    required this.selected,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  static const _months = [
    'янв.',
    'фев.',
    'мар.',
    'апр.',
    'май.',
    'июн.',
    'июл.',
    'авг.',
    'сен.',
    'окт.',
    ' ноя.',
    'дек.',
  ];
  static const _weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width:56, //64,
        //padding: const EdgeInsets.symmetric(vertical:2 /*10*/),
        decoration: BoxDecoration(
          color: selected ? const Color(0xff07aa55) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xff07aa55)/*scheme.primary */: Colors.black,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _months[date.month - 1],
              style: TextStyle(fontSize: 14, color: foreground),
            ),
            const SizedBox(height: 2),
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                height: 1.1,
                color: foreground,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _weekdays[date.weekday - 1],
              style: TextStyle(fontSize: 14, color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}
