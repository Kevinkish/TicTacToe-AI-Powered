import 'package:flutter/material.dart';

import '/domain/domain.dart';
import '/ui/ui.dart';

enum GameMode { twoPlayers, vsAI }

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

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      winner = null;
      isDraw = false;
    });
    if (selectedMode == GameMode.vsAI && currentPlayer == 'O') {
      _playAI();
    }
  }

  void _selectMode(GameMode mode) {
    setState(() {
      selectedMode = mode;
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
          // Ajoute un délai avant que l'ordinateur joue
          Future.delayed(const Duration(seconds: 1), _playAI);
        }
      }
    });
  }

  void _playAI() {
    // Simple AI: choose first available cell
    if (winner != null || isDraw) return;
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        setState(() {
          board[i] = 'O';
          winner = _checkWinner();
          if (winner == null && !board.contains('')) {
            isDraw = true;
          } else if (winner == null) {
            currentPlayer = 'X';
          }
        });
        break;
      }
    }
  }

  String? _checkWinner() {
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
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (winner != null || isDraw)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            spacing: 30,
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
                                color: colorScheme.primary.withValues(
                                  alpha: 0.08,
                                ),
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
                            // padding: EdgeInsets.zero,
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
