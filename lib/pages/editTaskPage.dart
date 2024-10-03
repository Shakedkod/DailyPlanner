import 'package:daily_planner/box.dart';
import 'package:daily_planner/components/inputField.dart';
import 'package:daily_planner/models/task.dart';
import 'package:daily_planner/services/dateServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:time_range_picker/time_range_picker.dart';

class EditTaskPage extends StatefulWidget 
{
    final Task task;
    const EditTaskPage({super.key, required this.task});

    @override
    State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> 
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
    void initState() 
    {
        super.initState();
        _selectedDate = widget.task.date;
        _titleController.text = widget.task.title;
        _detailsController.text = widget.task.details;
        _startTime = widget.task.startTime;
        _duration = widget.task.duration;
        _selectedColor = Color(widget.task.colorCode);
        _selectedIcon = IconData(widget.task.iconCodePoint, fontFamily: 'MaterialIcons');
        _repeatOption = widget.task.repetition.substring(0, 1).toUpperCase() + widget.task.repetition.substring(1);

        if (widget.task.repetition.startsWith('Custom')) 
        {
            _selectedDays = List.filled(7, false);
            for (int i = 0; i < 7; i++) 
            {
                if (_daysOfWeek.contains(widget.task.repetition.split(' ')[2])) 
                {
                    _selectedDays[_daysOfWeek.indexOf(widget.task.repetition.split(' ')[2])] = true;
                }
            }
            _repeatOption = 'Custom';
            _updateCustomRepeatDisplay();
        }
    }

    @override
    Widget build(BuildContext context) 
    {
        return Scaffold(
            appBar: AppBar(
                title: Row(
                    children: [
                        const Text("Update "),
                        Text(
                            "Task",
                            style: TextStyle(color: _selectedColor),
                        )
                    ],
                ),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
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
                                            _customRepeatDisplay, 
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
                            onPressed: _updateTask,
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text('Update Task'),
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

    void _updateSingleTask()
    {
        final task = Task(
            taskId: widget.task.taskId,
            title: _titleController.text,
            details: _detailsController.text,
            date: _selectedDate,
            startTime: _startTime,
            duration: _duration,
            colorCode: _selectedColor.value,
            iconCodePoint: _selectedIcon.codePoint,
            repetition: _repeatOption,
        );

        if (_repeatOption == 'Custom') 
        {
            List<String> selectedDays = [];

            for (int i = 0; i < 7; i++) 
            {
                if (_selectedDays[i]) 
                {
                    selectedDays.add(_daysOfWeek[i]);
                }
            }

            task.repetition = 'Custom ${selectedDays.join(" ")}';
        }

        final Map<dynamic, Task> tasksMap = tasksBox.toMap();
        tasksMap.forEach((k, v) {
            if (v.taskId == widget.task.taskId && DateServices.isSameDay(v.date, widget.task.date)) 
            {
                setState(() {
                    tasksBox.delete(k);
                });
            }
        });

        setState(() {
            tasksBox.add(task);
        });
    }

    void _updateAllFutureTasks()
    {
        // get all tasks with the same taskId & date >= selectedDate
        final tasks = tasksBox.values
            .where((task) => task.taskId == widget.task.taskId && task.date.isAfter(_selectedDate))
            .toList();
        
        List<Task> tasksToAdd = [];
        for (final task in tasks)
        {
            final newTask = Task(
                taskId: task.taskId,
                title: _titleController.text,
                details: _detailsController.text,
                date: task.date,
                startTime: _startTime,
                duration: _duration,
                colorCode: _selectedColor.value,
                iconCodePoint: _selectedIcon.codePoint,
                repetition: _repeatOption,
            );

            if (_repeatOption == 'Custom') 
            {
                List<String> selectedDays = [];

                for (int i = 0; i < 7; i++) 
                {
                    if (_selectedDays[i]) 
                    {
                        selectedDays.add(_daysOfWeek[i]);
                    }
                }

                newTask.repetition = 'Custom ${selectedDays.join(" ")}';
            }

            tasksToAdd.add(newTask);
        }

        final Map<dynamic, Task> tasksMap = tasksBox.toMap();
        tasksMap.forEach((k, v) {
            if (v.taskId == widget.task.taskId && v.date.isAfter(_selectedDate)) 
            {
                setState(() {
                    tasksBox.delete(k);
                });
            }
        });

        for (final task in tasksToAdd)
        {
            setState(() {
                tasksBox.add(task);
            });
        }

        _updateSingleTask();
    }

    void _updateTask() 
    {
        // check if the task has more instances and update them as well
        if (widget.task.repetition != 'Never') 
        {
            showDialog(context: context, builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text("Update all future tasks?"),
                    content: const Text("Do you want to update all future tasks as well?"),
                    actions: [
                        TextButton(
                            child: const Text('No'),
                            onPressed: () {
                                _updateSingleTask();
                                Navigator.pop(context);
                                Navigator.pop(context);
                            },
                        ),
                        TextButton(
                            child: const Text('Yes'),
                            onPressed: () {
                                _updateAllFutureTasks();
                                Navigator.pop(context);
                                Navigator.pop(context);
                            },
                        ),
                    ],
                );
            });
            // open dialog to ask if the user wants to update all future tasks
            showDialog(
                context: context,
                builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text('Update all future tasks?'),
                        content: const Text('Do you want to update all future tasks as well?'),
                        actions: <Widget>[
                            TextButton(
                                child: const Text('No'),
                                onPressed: () {
                                    Navigator.of(context).pop();
                                    _updateSingleTask();
                                },
                            ),
                            TextButton(
                                child: const Text('Yes'),
                                onPressed: () {
                                    Navigator.of(context).pop();
                                    _updateAllFutureTasks();
                                },
                            ),
                        ],
                    );
                },
            );
        }
        else
        {
            _updateSingleTask();
        }

        Navigator.pop(context);
    }
}