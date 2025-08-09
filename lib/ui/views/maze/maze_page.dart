import 'package:flutter/material.dart';
import '/domain/domain.dart';
import '/ui/ui.dart';

class MazePage extends StatefulWidget {
  const MazePage({super.key});

  @override
  State<MazePage> createState() => _MazePageState();
}

class _MazePageState extends State<MazePage> {
  static const int rows = 10;
  static const int cols = 15;

  // Maze legend: '#' = wall, ' ' = path, 'A' = start, 'B' = goal
  List<List<String>> maze = List.generate(
    rows,
    (i) => List.generate(cols, (j) => ' '),
  );

  late List<List<bool>> walls;
  late (int, int) start;
  late (int, int) goal;
  Set<(int, int)> solution = {};
  Set<(int, int)> explored = {};
  bool _showNoSolution = false;

  @override
  void initState() {
    super.initState();
    _generateSampleMaze();
    // Ne pas appeler _solveMaze ici si tu veux afficher le SnackBar
    // Appelle-le dans didChangeDependencies ou dans build après le premier build si besoin
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _solveMaze();
    });
  }

  void _generateSampleMaze() {
    // Simple static maze for demo (can be randomized or loaded from file)
    // You can modify this maze as you wish
    const raw = [
      "###############",
      "#A   #     #  #",
      "# # # ### # # #",
      "# #   #   # # #",
      "# ### # ### # #",
      "#     #     # #",
      "### ####### # #",
      "#         #   #",
      "# ####### ###B#",
      "###############",
    ];
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        maze[i][j] = raw[i][j];
      }
    }
    walls = List.generate(
      rows,
      (i) => List.generate(cols, (j) => maze[i][j] == '#'),
    );
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (maze[i][j] == 'A') start = (i, j);
        if (maze[i][j] == 'B') goal = (i, j);
      }
    }
  }

  void _solveMaze() {
    explored.clear();
    solution.clear();
    final stack = <_Node>[];
    stack.add(_Node(state: start, parent: null, action: null));
    bool found = false;
    while (stack.isNotEmpty) {
      final node = stack.removeLast();
      if (explored.contains(node.state)) continue;
      explored.add(node.state);
      if (node.state == goal) {
        // Reconstruct path
        var n = node;
        while (n.parent != null) {
          solution.add(n.state);
          n = n.parent!;
        }
        found = true;
        break;
      }
      for (final neighbor in _neighbors(node.state)) {
        if (!explored.contains(neighbor)) {
          stack.add(_Node(state: neighbor, parent: node, action: null));
        }
      }
    }
    setState(() {
      _showNoSolution = !found;
    });
  }

  List<(int, int)> _neighbors((int, int) state) {
    final row = state.$1, col = state.$2;
    final candidates = [
      (row - 1, col),
      (row + 1, col),
      (row, col - 1),
      (row, col + 1),
    ];
    return candidates.where((pos) {
      final r = pos.$1, c = pos.$2;
      return r >= 0 && r < rows && c >= 0 && c < cols && !walls[r][c];
    }).toList();
  }

  Color _cellColor(int i, int j) {
    if (walls[i][j]) return Colors.black;
    if ((i, j) == start) return Colors.red;
    if ((i, j) == goal) return Colors.green;
    if (solution.contains((i, j))) return Colors.yellow.shade300;
    if (explored.contains((i, j))) return Colors.blue.shade100;
    return Colors.white;
  }

  Widget _buildMazeGrid() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey.shade800,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(rows, (i) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(cols, (j) {
              return Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: _cellColor(i, j),
                  border: Border.all(color: Colors.grey.shade700, width: 0.5),
                ),
                child: Center(
                  child: maze[i][j] == 'A'
                      ? const Text(
                          'A',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : maze[i][j] == 'B'
                      ? const Text(
                          'B',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ThemeUtil.colorScheme(context);

    // Affiche le SnackBar après le build si besoin
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showNoSolution) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pas de solution trouvée pour ce labyrinthe."),
          ),
        );
        setState(() {
          _showNoSolution = false;
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maze Solver'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Labyrinthe (DFS Solver)",
              style: ThemeUtil.txtTheme(
                context,
              ).headlineMedium?.copyWith(color: colorScheme.primary),
            ),
            SizeUtil.heightGap(16),
            _buildMazeGrid(),
            SizeUtil.heightGap(24),
            ElevatedButton.icon(
              onPressed: () {
                _solveMaze();
              },
              icon: const Icon(Icons.route),
              label: const Text("Résoudre à nouveau"),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                textStyle: ThemeUtil.txtTheme(context).titleMedium,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Node {
  final (int, int) state;
  final _Node? parent;
  final String? action;
  _Node({required this.state, this.parent, this.action});
}
