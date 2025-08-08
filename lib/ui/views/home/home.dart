import 'package:flutter/material.dart';

import '/domain/domain.dart';
import '/ui/ui.dart';

enum GameMode { twoPlayers, vsAI }

enum AiLevel { amateur, pro, legend }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  String? winner;
  bool isDraw = false;
  GameMode? selectedMode;
  AiLevel? aiLevel;

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      winner = null;
      isDraw = false;
    });
    if (selectedMode == GameMode.vsAI && currentPlayer == 'O') {
      Future.delayed(const Duration(milliseconds: 700), _playAI);
    }
  }

  void _selectMode(GameMode mode) {
    setState(() {
      selectedMode = mode;
      aiLevel = null;
      _resetGame();
    });
  }

  void _selectAiLevel(AiLevel level) {
    setState(() {
      aiLevel = level;
      _resetGame();
    });
  }

  void _handleTap(int index) {
    if (board[index] != '' || winner != null) return;
    setState(() {
      board[index] = currentPlayer;
      winner = _checkWinner();
      if (winner == null && !board.contains('')) {
        isDraw = true;
      } else if (winner == null) {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        if (selectedMode == GameMode.vsAI && currentPlayer == 'O' && !isDraw) {
          Future.delayed(const Duration(milliseconds: 700), _playAI);
        }
      }
    });
  }

  // --- AI LOGIC WITH LEVELS ---
  void _playAI() async {
    if (winner != null || isDraw || aiLevel == null) return;
    int? move = _findBestMove(board, aiLevel!);
    if (move != null) {
      setState(() {
        board[move] = 'O';
        winner = _checkWinner();
        if (winner == null && !board.contains('')) {
          isDraw = true;
        } else if (winner == null) {
          currentPlayer = 'X';
        }
      });
    }
  }

  int? _findBestMove(List<String> board, AiLevel level) {
    List<int> empty = [];
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') empty.add(i);
    }
    if (empty.isEmpty) return null;

    // Amateur: 60% random, 40% minimax (depth 1)
    if (level == AiLevel.amateur) {
      if (_randomChance(0.6)) {
        return (empty..shuffle()).first;
      } else {
        return _minimaxMove(board, maxDepth: 1);
      }
    }
    // Pro: 30% random, 70% minimax (depth 3)
    if (level == AiLevel.pro) {
      if (_randomChance(0.3)) {
        return (empty..shuffle()).first;
      } else {
        return _minimaxMove(board, maxDepth: 3);
      }
    }
    // Legend: always minimax full
    return _minimaxMove(board, maxDepth: null);
  }

  bool _randomChance(double chance) => (chance > 0 && chance < 1)
      ? (UniqueKey().hashCode % 1000) / 1000.0 < chance
      : false;

  int? _minimaxMove(List<String> board, {int? maxDepth}) {
    int? bestMove;
    int bestScore = -1000;
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = 'O';
        int score = _minimax(board, 0, false, maxDepth);
        board[i] = '';
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }
    return bestMove;
  }

  int _minimax(List<String> board, int depth, bool isMax, int? maxDepth) {
    String? win = _checkWinnerFor(board);
    if (win == 'O') return 10 - depth;
    if (win == 'X') return depth - 10;
    if (!board.contains('')) return 0;
    if (maxDepth != null && depth >= maxDepth) return 0;

    int bestScore = isMax ? -1000 : 1000;
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = isMax ? 'O' : 'X';
        int score = _minimax(board, depth + 1, !isMax, maxDepth);
        board[i] = '';
        if (isMax) {
          bestScore = score > bestScore ? score : bestScore;
        } else {
          bestScore = score < bestScore ? score : bestScore;
        }
      }
    }
    return bestScore;
  }

  String? _checkWinnerFor(List<String> board) {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var pattern in winPatterns) {
      final a = pattern[0], b = pattern[1], c = pattern[2];
      if (board[a] != '' && board[a] == board[b] && board[a] == board[c]) {
        return board[a];
      }
    }
    return null;
  }

  String? _checkWinner() => _checkWinnerFor(board);

  Widget _buildCell(int index) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: ThemeUtil.colorScheme(context).primary,
            width: 3,
          ),
        ),
        child: Center(
          child: Text(
            board[index],
            style: ThemeUtil.txtTheme(context).displayLarge?.copyWith(
              color: board[index] == 'X'
                  ? ThemeUtil.colorScheme(context).primary
                  : ThemeUtil.colorScheme(context).secondary,
              fontWeight: FontWeight.bold,
              fontSize: 70,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ThemeUtil.colorScheme(context);
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppImages.game1,
            fit: BoxFit.cover,
            width: SizeUtil.sizeWidth(context),
            height: SizeUtil.sizeHeight(context),
          ),
          Center(
            child: selectedMode == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Choisissez un mode de jeu',
                        style: ThemeUtil.txtTheme(
                          context,
                        ).headlineMedium?.copyWith(color: colorScheme.surface),
                      ),
                      SizeUtil.heightGap(32),
                      ElevatedButton.icon(
                        onPressed: () => _selectMode(GameMode.twoPlayers),
                        icon: const Icon(Icons.people),
                        label: const Text('Deux joueurs'),
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
                      SizeUtil.heightGap(16),
                      ElevatedButton.icon(
                        onPressed: () => _selectMode(GameMode.vsAI),
                        icon: const Icon(Icons.smart_toy),
                        label: const Text('Jouer contre l\'ordinateur'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.secondary,
                          foregroundColor: colorScheme.onSecondary,
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
                  )
                : selectedMode == GameMode.vsAI && aiLevel == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Choisissez le niveau de l\'IA',
                        style: ThemeUtil.txtTheme(
                          context,
                        ).headlineMedium?.copyWith(color: colorScheme.surface),
                      ),
                      SizeUtil.heightGap(32),
                      ElevatedButton.icon(
                        onPressed: () => _selectAiLevel(AiLevel.amateur),
                        icon: const Icon(Icons.sentiment_satisfied),
                        label: const Text('Amateur'),
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
                      SizeUtil.heightGap(16),
                      ElevatedButton.icon(
                        onPressed: () => _selectAiLevel(AiLevel.pro),
                        icon: const Icon(Icons.emoji_events),
                        label: const Text('Pro'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.secondary,
                          foregroundColor: colorScheme.onSecondary,
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
                      SizeUtil.heightGap(16),
                      ElevatedButton.icon(
                        onPressed: () => _selectAiLevel(AiLevel.legend),
                        icon: const Icon(Icons.star),
                        label: const Text('Légende'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.tertiary,
                          foregroundColor: colorScheme.onTertiary,
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
                      SizeUtil.heightGap(32),
                      ElevatedButton.icon(
                        onPressed: () => setState(() {
                          selectedMode = null;
                        }),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Retour'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.secondary,
                          foregroundColor: colorScheme.onSecondary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          textStyle: ThemeUtil.txtTheme(context).titleMedium,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (winner != null || isDraw)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            children: [
                              Icon(
                                isDraw
                                    ? AppIcons.equal(context).icon
                                    : AppIcons.congrats(context).icon,
                                size: 50,
                                color: AppColors.white0,
                              ),
                              Text(
                                winner != null
                                    ? 'Le joueur $winner a gagné !'
                                    : 'Match nul !',
                                style: ThemeUtil.txtTheme(context)
                                    .headlineMedium
                                    ?.copyWith(color: colorScheme.surface),
                              ),
                            ],
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            selectedMode == GameMode.vsAI
                                ? (currentPlayer == 'X'
                                      ? 'Votre tour'
                                      : 'Tour de l\'ordinateur')
                                : 'Tour du joueur $currentPlayer',
                            style: ThemeUtil.txtTheme(context).headlineMedium
                                ?.copyWith(color: colorScheme.surface),
                          ),
                        ),
                      if (winner != null || isDraw)
                        Container()
                      else
                        Container(
                          width: 400,
                          height: 400,
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withAlpha(20),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: GridView.builder(
                            itemCount: 9,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => _buildCell(index),
                          ),
                        ),
                      SizeUtil.heightGap(24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _resetGame,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Recommencer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              textStyle: ThemeUtil.txtTheme(
                                context,
                              ).titleMedium,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizeUtil.widthGap(16),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                selectedMode = null;
                              });
                            },
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Changer de mode'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.secondary,
                              foregroundColor: colorScheme.onSecondary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              textStyle: ThemeUtil.txtTheme(
                                context,
                              ).titleMedium,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
