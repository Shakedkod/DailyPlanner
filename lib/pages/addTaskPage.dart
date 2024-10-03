import 'package:daily_planner/box.dart';
import 'package:daily_planner/components/inputField.dart';
import 'package:daily_planner/models/task.dart';
import 'package:daily_planner/services/dateServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:uuid/uuid.dart';

class AddTaskPage extends StatefulWidget 
{
    const AddTaskPage({super.key});

    @override
    State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> 
{
    final List<Color> _availableColors = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.orange,
    ];

    final List<String> _repeatOptions = [
        'Never',
        'Daily',
        'Weekly',
        'Monthly',
        'Yearly',
        'Custom',
    ];

    final List<String> _customRepeatUnits = [
        'Day',
        'Week',
        'Month',
        'Year',
    ];

    final List<String> _daysOfWeek = [
        'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];

    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _detailsController = TextEditingController();
    DateTime _selectedDate = DateTime.now();
    TimeOfDay _startTime = TimeOfDay.now();
    Duration _duration = const Duration(minutes: 60);
    Color _selectedColor = Colors.grey;
    IconData _selectedIcon = Icons.event;
    String _repeatOption = 'Never';

    // Custom repeat variables
    List<bool> _selectedDays = List.filled(7, false);
    String _customRepeatDisplay = '';

    @override
    Widget build(BuildContext context) 
    {
        return Scaffold(
            appBar: AppBar(
                title: Row(
                    children: [
                        const Text("New "),
                        Text(
                            "Task",
                            style: TextStyle(color: _selectedColor),
                        )
                    ],
                ),
                leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                ),
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Row(
                            children: [
                                GestureDetector(
                                    onTap: _pickIcon,
                                    child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(_selectedIcon, size: 30),
                                    ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                    child: InputField(
                                        hint: "Enter task name",
                                        underlineColor: _selectedColor,
                                        controller: _titleController,
                                    ),
                                ),
                            ],
                        ),
                        const SizedBox(height: 20),
                        const Text('When?', style: TextStyle(fontSize: 16)),
                        Row(
                            children: [
                                Expanded(
                                    child: ElevatedButton(
                                        onPressed: _selectTimeRange,
                                        child: Text('${_startTime.format(context)} - ${_calculateEndTime().format(context)}'),
                                    ),
                                ),
                                IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: _selectDate,
                                ),
                            ],
                        ),
                        const SizedBox(height: 20),
                        const Text('How long?', style: TextStyle(fontSize: 16)),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: [15, 30, 45, 60, 90].map((int minutes) {
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                        child: ChoiceChip(
                                            label: Text('${minutes}m'),
                                            selectedColor: _selectedColor.withOpacity(0.5),
                                            selected: _duration.inMinutes == minutes,
                                            onSelected: (bool selected) {
                                                if (selected) {
                                                    setState(() {
                                                        _duration = Duration(minutes: minutes);
                                                    });
                                                }
                                            },
                                        ),
                                    );
                                }).toList(),
                            ),
                        ),
                        const SizedBox(height: 20),
                        const Text('What color?', style: TextStyle(fontSize: 16)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                                ..._availableColors.map((Color color) {
                                    return GestureDetector(
                                        onTap: () => setState(() => _selectedColor = color),
                                        child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: color,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: _selectedColor == color ? Colors.black : Colors.transparent,
                                                    width: 2,
                                                ),
                                            ),
                                        ),
                                    );
                                }),
                                GestureDetector(
                                    onTap: _openColorPicker,
                                    child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: const Color(0xFFFFF8E1), width: 2),
                                            gradient: const LinearGradient(
                                                colors: [Colors.amber, Colors.deepOrange, Colors.blue, Colors.lightBlue],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                            ),
                                        ),
                                    ),
                                ),
                            ]
                        ),
                        const SizedBox(height: 20),
                        const Text('Repeats', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Row(
                            children: [
                                Expanded(
                                    child: DropdownButton<String>(
                                        value: _repeatOption,
                                        isExpanded: true,
                                        onChanged: (String? newValue) {
                                            if (newValue != null) {
                                                setState(() {
                                                    _repeatOption = newValue;
                                                    if (newValue == 'Custom') {
                                                        _openCustomRepeatDialog();
                                                    }
                                                });
                                            }
                                        },
                                        items: _repeatOptions.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                            );
                                        }).toList(),
                                    ),
                                ),
                                if (_repeatOption == 'Custom')
                                    Expanded(
                                        child: Text(
                                            _customRepeatDisplay.replaceAll("Custom ", ""), 
                                            style: const TextStyle(fontSize: 14)
                                        ),
                                    ),
                            ],
                        ),
                        const SizedBox(height: 20),
                        const Text('Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        TextField(
                            maxLines: 3,
                            decoration: InputDecoration(
                                hintText: 'Add details',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: _selectedColor),
                                    borderRadius: BorderRadius.circular(8),
                                ),
                            ),
                            controller: _detailsController,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: _createTask,
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text('Create Task'),
                        ),
                    ],
                ),
            ),
        );
    }

    TimeOfDay _calculateEndTime() => TimeOfDay(
        hour: _startTime.hour + _duration.inHours,
        minute: _startTime.minute + (_duration.inMinutes % 60),
    );

    void _selectTimeRange() async 
    {
        final time = await showTimeRangePicker(
            context: context,
            start: _startTime,
            end: _calculateEndTime(),
            handlerColor: _selectedColor,
            strokeColor: _selectedColor,
            ticksColor: _selectedColor,
            paintingStyle: PaintingStyle.stroke,
            use24HourFormat: true,
            ticks: 24,
            labels: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"].asMap().entries.map((e) {
                return ClockLabel.fromIndex(
                    idx: e.key, length: 24, text: e.value);
            }).toList(),
        );

        if (time != null) 
            setState(() {
                _startTime = time.startTime;
                _duration = DateServices.calculateDuration(time.startTime, time.endTime);
            });
    }

    void _selectDate() async 
    {
        final date = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365*5)),
            barrierColor: _selectedColor.withOpacity(0.02),
        );

        if (date != null) 
            setState(() {
                _selectedDate = date;
            });
    }

    void _pickIcon() async 
    {
        showIconPicker(
            context,
            configuration: SinglePickerConfiguration(
                adaptiveDialog: true,
                iconPackModes: const [IconPack.outlinedMaterial],
                iconBuilder: (context, icon, isSelected, onTap)
                {
                    return GestureDetector(
                        onTap: ()
                        {
                            onTap(icon);
                            setState(() => _selectedIcon = icon.data);
                            Navigator.pop(context);
                        },
                        child: Container(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: isSelected ? Colors.blue : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(icon.data, size: 30, color: const Color(0xFF000322)),
                        ),
                    );
                }
            )
        );
    }

    void _openColorPicker() {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Pick a color'),
                    content: SingleChildScrollView(
                        child: ColorPicker(
                            pickerColor: _selectedColor,
                            onColorChanged: (Color color) {
                                setState(() => _selectedColor = color);
                            },
                            labelTypes: const [],
                            pickerAreaHeightPercent: 0.8,
                        ),
                    ),
                    actions: <Widget>[
                        TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                                Navigator.of(context).pop();
                            },
                        ),
                    ],
                );
            },
        );
    }

    void _openCustomRepeatDialog() 
    {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                            title: const Text('Custom Repeat'),
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                    const Text('Repeat on:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Wrap(
                                        spacing: 8.0,
                                        children: List.generate(7, (index) {
                                            return FilterChip(
                                                label: Text(_daysOfWeek[index]),
                                                selected: _selectedDays[index],
                                                onSelected: (bool selected) {
                                                    setState(() {
                                                        _selectedDays[index] = selected;
                                                    });
                                                },
                                            );
                                        }),
                                    ),
                                ],
                            ),
                            actions: <Widget>[
                                TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                        Navigator.of(context).pop();
                                        this.setState(() {
                                            _repeatOption = 'Never';
                                            _selectedDays = List.filled(7, false);
                                        });
                                    },
                                ),
                                TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                        Navigator.of(context).pop();
                                        this.setState(() {
                                            _updateCustomRepeatDisplay();
                                        });
                                    },
                                ),  
                            ],
                        );
                    },
                );
            },
        );
    }

    void _updateCustomRepeatDisplay() 
    {
        List<String> selectedDays = [];

        for (int i = 0; i < 7; i++) {
            if (_selectedDays[i]) {
                selectedDays.add(_daysOfWeek[i]);
            }
        }

        if (selectedDays.isEmpty) 
        {
            _repeatOption = 'Never';
            _customRepeatDisplay = '';
        }
        else if (selectedDays.length == 7) 
        {
            _customRepeatDisplay = 'Custom Every day';
        } 
        else 
        {
            _customRepeatDisplay = 'Custom Every ${selectedDays.join(", ")}';
        }
    }

    void _createTask() 
    {
        String taskId = const Uuid().v4();

        if (_repeatOption == 'Custom' && _customRepeatDisplay.isEmpty) 
        {
            _openCustomRepeatDialog();
            return;
        }

        if (_repeatOption == 'Custom') 
        {
            _repeatOption = _customRepeatDisplay;

            for (int j = 0; j < DateServices.numOfWeeksInMonth(DateTime.now().month); j++) 
            {
                for (int i = 0; i < 7; i++) 
                {
                    if (_selectedDays[i]) 
                    {
                        final date = DateServices.mostRecentWeekday(DateTime.now(), i + 1).add(Duration(days: j * 7));
                        final task = Task(
                            taskId: taskId,
                            title: _titleController.text,
                            date: date,
                            startTime: _startTime,
                            duration: _duration,
                            colorCode: _selectedColor.value,
                            iconCodePoint: _selectedIcon.codePoint,
                            repetition: _repeatOption,
                            details: _detailsController.text,
                        );

                        tasksBox.add(task);
                    }
                }
            }
        }
        else if (_repeatOption == "Daily")
        {
            for (int i = 0; i < 365; i++)
            {
                final date = DateTime.now().add(Duration(days: i));
                final task = Task(
                    taskId: taskId,
                    title: _titleController.text,
                    date: date,
                    startTime: _startTime,
                    duration: _duration,
                    colorCode: _selectedColor.value,
                    iconCodePoint: _selectedIcon.codePoint,
                    repetition: _repeatOption,
                    details: _detailsController.text,
                );

                tasksBox.add(task);
            }
        }
        else if (_repeatOption == "Weekly")
        {
            for (int i = 0; i < 52; i++)
            {
                final date = DateTime.now().add(Duration(days: i * 7));
                final task = Task(
                    taskId: taskId,
                    title: _titleController.text,
                    date: date,
                    startTime: _startTime,
                    duration: _duration,
                    colorCode: _selectedColor.value,
                    iconCodePoint: _selectedIcon.codePoint,
                    repetition: _repeatOption,
                    details: _detailsController.text,
                );

                tasksBox.add(task);
            }
        }
        else if (_repeatOption == "Monthly")
        {
            for (int i = 0; i < 12; i++)
            {
                final date = DateTime(DateTime.now().year, DateTime.now().month + i, DateTime.now().day);
                final task = Task(
                    taskId: taskId,
                    title: _titleController.text,
                    date: date,
                    startTime: _startTime,
                    duration: _duration,
                    colorCode: _selectedColor.value,
                    iconCodePoint: _selectedIcon.codePoint,
                    repetition: _repeatOption,
                    details: _detailsController.text,
                );

                tasksBox.add(task);
            }
        }
        else if (_repeatOption == "Yearly")
        {
            for (int i = 0; i < 5; i++)
            {
                final date = DateTime(DateTime.now().year + i, DateTime.now().month, DateTime.now().day);
                final task = Task(
                    taskId: taskId,
                    title: _titleController.text,
                    date: date,
                    startTime: _startTime,
                    duration: _duration,
                    colorCode: _selectedColor.value,
                    iconCodePoint: _selectedIcon.codePoint,
                    repetition: _repeatOption,
                    details: _detailsController.text,
                );

                tasksBox.add(task);
            }
        }
        else
        {
            final task = Task(
                taskId: taskId,
                title: _titleController.text,
                date: _selectedDate,
                startTime: _startTime,
                duration: _duration,
                colorCode: _selectedColor.value,
                iconCodePoint: _selectedIcon.codePoint,
                repetition: _repeatOption,
                details: _detailsController.text,
            );

            tasksBox.add(task);
        }

        Navigator.pop(context);
    }
}