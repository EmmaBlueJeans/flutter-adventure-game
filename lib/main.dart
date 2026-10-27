import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- ENTRY POINT -------------
// main is the first function that runs
// It creates a MateralApp and sets AdventureGame as the homescreen.

void main() => runApp(MaterialApp(
  title: 'Choose Your Adventure Game',
  home: AdventureGame(),
));


//--- WIDGET SHELL ---
// AdventureGame is a StatefulWidget - a container or shell
// It doesn't store the data itself, just creates the State object where the game lives

class AdventureGame extends StatefulWidget {
  @override
  _AdventureGameState createState() => _AdventureGameState();
}

// --- STATE CLASS -----The HEART OF THE APP
//AdventureGameState:
// - holds all the game data (STATE VARIABLE) that changes over time
// - holds METHODS that change the state (movement, pick up items, reset)
// - holds the BUILD METHOD - what the UI should look like based on current state

class _AdventureGameState extends State<AdventureGame> {

  //-----------------STATE VARIABLES------------------------------

  //which room the player is currently in (0-6)
  // This is how I represent the map: each room has an integer ID
  // //(this is connected to the build method where an if/else chain checks state)
  int _currentRoom = 1;


  int _itemsCollected = 0;  // how many items the player has picked up

  //For the "items in rooms" requirement:
  // Flags to track if the player already pick up the item in each item room
  // These prevent items from reappearing and being collected twice.
  bool _pickedRoom2Item = false;
  bool _pickedRoom3Item = false;
  bool _pickedRoom4Item = false;
  bool _pickedRoom5Item = false;

  //Game rules:
  // These define the rules
  // - which room is the exit
  // - which room is the trap
  // - how many items are required to win
  final int _exitRoom = 1;       // Entrance Hall is the only exit
  final int _trapRoom = 6;       // Room (Dungeon) is the trap
  final int _requiredItems = 4;  // Must collect 4 items to win

  //Game outcome flags
  // These mark whether the game is over and if the player won or lost
  bool _lost = false;
  bool _won = false;


  //------------ METHODS / GAME ACTIONS. -------------------
  // Methods use setState so the screen is rebuilt when something changes

  // Handles moving between rooms
  // - Player taps a direction button.
  // - The button calls _moveTo(nextRoomId).
  // - We update _currentRoom.
  // - Then we check the game rules for trap or win:
  //   • If we stepped into the trap room, mark _lost = true.
  //   • Else if we are in the exit room AND we have enough items,
  //     mark _won = true.

  // If the game is already over, we ignore further movement.
  void _moveTo(int nextRoom) {
    if (_lost || _won) return;   //If the game is already over, ignore movement

    setState(() {
      _currentRoom = nextRoom;

      // 1) Check for trap first - stepping into the trap room ends the game
      if (_currentRoom == _trapRoom) {
        _lost = true;
      }

      // 2) Check for win (must be at exit + enough items)
      else if (_currentRoom == _exitRoom &&
          _itemsCollected >= _requiredItems) {
        _won = true;
      }
      //Otherwise, nothing special - player just continues exploring
    });
  }

  // Handles picking up an item in the current room
  // - I needed a count of items (_itemsCollected),
  //   plus a way to know which rooms' items were already picked up
  //   (the _pickedRoomXItem booleans).
  // - This method:
  //   • checks which room we are in
  //   • checks if that room’s item has not been picked up yet
  //   • flips the flag to true and increments _itemsCollected
  //
  // This ensures each item can only be picked up once.
  void _pickUpItemInCurrentRoom() {
    setState(() {
      if (_currentRoom == 2 && !_pickedRoom2Item) {
        _pickedRoom2Item = true;
        _itemsCollected++;
      } else if (_currentRoom == 3 && !_pickedRoom3Item) {
        _pickedRoom3Item = true;
        _itemsCollected++;
      } else if (_currentRoom == 4 && !_pickedRoom4Item) {
        _pickedRoom4Item = true;
        _itemsCollected++;
      } else if (_currentRoom == 5 && !_pickedRoom5Item) {
        _pickedRoom5Item = true;
        _itemsCollected++;
      }
    });
  }

  // Resets the game back to starting state
  // Called from the "Play Again" button on win/lose screens
  void _resetGame() {
    setState(() {
      _currentRoom = _exitRoom;  //start back in the entrance hall (also exit room)
      _itemsCollected = 0;

      // Reset all item flags so items can be collected again
      _pickedRoom2Item = false;
      _pickedRoom3Item = false;
      _pickedRoom4Item = false;
      _pickedRoom5Item = false;

      // Clear game outcome flags
      _lost = false;
      _won = false;
    });
  }

  // ---- BUILD METHOD -------------
  // This method decides what the UI looks like based on the current state

  // - All the changing data lives in the state variables above.
  // - build() just *reacts* to those values and returns the appropriate UI:
  //   • If _lost is true -> show Game Over screen.
  //   • If _won is true  -> show Victory screen.
  //   • Otherwise        -> show the normal in-game screen
  //                         with room description, item buttons, and movement.

  @override
  Widget build(BuildContext context) {
    String roomText = '';
    List<Widget> buttons = [];
    // adding header with room logic to show icons for rooms
    String roomTitle = '';
    IconData roomIcon = Icons.meeting_room;
    Color roomIconColor = Colors.indigo;

    //--- GAME OVER: LOSE SCREEN ---------
    //If _lost is true:
    // - Show a special "You lose" Scaffold
    // - Show a Play Again button (calls_resetGame)
    // - Show an Exit Game button (closes the app)
    if (_lost) {
        return Scaffold(
          backgroundColor: Colors.indigo[50],
          appBar: AppBar(
            title: const Text('Choose Your Adventure Game'),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'You were trapped in the Dungeon!\nYou lose.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _resetGame,
                    child: const Text('Play Again'),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(12.0),
            child: OutlinedButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text('Exit Game'),
            ),

          ),
        );
      }

   // -------- GAME OVER : WIN SCREEN --------------------
    // If win is true:
    // - Show a "Victory" Scaffold with a trophy icon and stats
    // - Provide Play Again + Exit buttons, similar to the lose screen
    if (_won) {
      return Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: const Text('Victory!'),
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Trophy for the win!
                Icon(
                  Icons.emoji_events,
                  size: 80,
                  color: Colors.amber[700],
                ),
                const SizedBox(height: 16),

                const Text(
                  'YOU WIN!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
          const SizedBox(height: 12),

                Text(
                  '🎉 You escaped the castle with 4 items! 🎉',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
                ),

                const SizedBox(height: 24),

                // Show a summary of the items collected (should be 4)
                Text(
                  'Items collected: $_itemsCollected / $_requiredItems',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),

                //Play again button
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  onPressed: _resetGame,
                  child: const Text('Play Again', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12.0),
          child: OutlinedButton(
            onPressed: () => SystemNavigator.pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green[700],
              side: BorderSide(color: Colors.green.shade400, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Exit Game', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ),
      );
    }


    // From here down is the "normal" in-game UI.

    // A shared style for direction buttons (N/E/S/W)
    final ButtonStyle directionButtonStyle = ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo[400],
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          )
    );

    // --- ROOM LOGIC -----

    // - I use _currentRoom to represent where the player is.
    // - For each room ID:
    //   • set roomText to describe the room
    //   • build the buttons list with only the available exits
    //
    // For example:
    // - In the Banquet Hall (room 2), the player can go West, East, or South,
    //   so only those buttons are created.
    //
    // When the user taps a button, it calls _moveTo(...) with the target room.

        if (_currentRoom == 0) {
          roomTitle = 'Outside the Castle';
          roomIcon = Icons.park;
          roomText = 'You are outside the castle.  Go East to re-enter.';
          roomIconColor = Colors.green;
          buttons = [
            ElevatedButton(
              style: directionButtonStyle,
              onPressed: () => _moveTo(1),
              child: const Text('East'),
            ),
          ];
        } else if (_currentRoom == 1) {
          roomTitle = 'Entrance Hall';
          roomIcon = Icons.door_front_door;
          roomText = 'Entrance Hall: tapestries and a big wooden door.';
          roomIconColor = Colors.purple;
          buttons = [
            ElevatedButton(style: directionButtonStyle, onPressed: () => _moveTo(0), child: const Text('West')),
            ElevatedButton(style: directionButtonStyle, onPressed: () => _moveTo(2), child: const Text('East')),
            ElevatedButton(style: directionButtonStyle, onPressed: () => _moveTo(6), child: const Text('South')),
          ];
        } else if (_currentRoom == 2) {
          roomTitle = 'Banquet Hall';
          roomIcon = Icons.restaurant;
          roomText = 'Banquet Hall: long table, half-eaten feast.';
          roomIconColor = Colors.brown;
          buttons = [
            ElevatedButton(style: directionButtonStyle, onPressed: () => _moveTo(1), child: const Text('West')),
            ElevatedButton(style: directionButtonStyle, onPressed: () => _moveTo(3), child: const Text('East')),
            ElevatedButton(style: directionButtonStyle, onPressed: () => _moveTo(5), child: const Text('South')),
          ];
        } else if (_currentRoom == 3) {
          roomTitle = 'Kitchen';
          roomIcon = Icons.kitchen;
          roomText = 'Kitchen: hot stoves and hanging pots.';
          roomIconColor = Colors.orange;
          buttons = [
            ElevatedButton(style: directionButtonStyle, onPressed: () => _moveTo(2), child: const Text('West')),
            ElevatedButton(style: directionButtonStyle, onPressed: () => _moveTo(4), child: const Text('South')),
          ];
        } else if (_currentRoom == 4) {
          roomTitle = 'Library';
          roomIcon = Icons.library_books;
          roomText = 'Library: shelves to the ceiling.';
          roomIconColor = Colors.blue;
          buttons = [
            ElevatedButton(style: directionButtonStyle, onPressed: () => _moveTo(3), child: const Text('North')),
            ElevatedButton(style: directionButtonStyle, onPressed: () => _moveTo(5), child: const Text('West')),
          ];
        } else if (_currentRoom == 5) {
          roomTitle = 'Armory';
          roomIcon = Icons.shield_sharp;
          roomText = 'Armory: weapons on the walls.';
          roomIconColor = Colors.grey;
          buttons = [
            ElevatedButton(style: directionButtonStyle, onPressed: () => _moveTo(6), child: const Text('West')),
            ElevatedButton(style: directionButtonStyle, onPressed: () => _moveTo(2), child: const Text('North')),
            ElevatedButton(style: directionButtonStyle, onPressed: () => _moveTo(4), child: const Text('East')),
          ];
        } else if (_currentRoom == 6) {
          roomTitle = 'Dungeon';
          roomIcon = Icons.bug_report;
          roomText = 'Dungeon: cold, damp, and dark.';
          roomIconColor = Colors.red;
          buttons = [
            ElevatedButton(style: directionButtonStyle, onPressed: () => _moveTo(5), child: const Text('East')),
            ElevatedButton(style: directionButtonStyle, onPressed: () => _moveTo(1), child: const Text('North')),
          ];
        }


        // --- MAIN IN-GAME SCREEN LAYOUT ---------------------------------

        return Scaffold(
          backgroundColor: Colors.indigo[50],
          appBar: AppBar(
            title: const Text('Choose Your Adventure Game'),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // Room header: icon + title
                Row(
                  children: [
                    Icon(roomIcon, size: 28, color: roomIconColor),
                    const SizedBox(width: 8),
                    Text(
                      roomTitle,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Room description text
                Text(
                  roomText,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Show how many items the player has collected so far
                Text(
                  'Items collected: $_itemsCollected / 4',
                  style: const TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 8),

                // Simple icons to represent collected items
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _itemsCollected >= 1 ? Icons.circle : Icons.circle_outlined,
                      size: 20,
                      color: Colors.amber[700],
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _itemsCollected >= 2 ? Icons.circle : Icons.circle_outlined,
                      size: 20,
                      color: Colors.amber[700],
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _itemsCollected >= 3 ? Icons.circle : Icons.circle_outlined,
                      size: 20,
                      color: Colors.amber[700],
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _itemsCollected >= 4 ? Icons.circle : Icons.circle_outlined,
                      size: 20,
                      color: Colors.amber[700],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ITEM PICKUP BUTTONS
                // Each block:
                // - Only shows when we are in that room AND the item hasn't been picked up yet.
                // - When tapped, calls _pickUpItemInCurrentRoom() which updates the state.
                if (_currentRoom == 2 && !_pickedRoom2Item)
                  ElevatedButton(
                    onPressed: _pickUpItemInCurrentRoom,
                    child: const Text('Pick up Golden Chalice'),
                  ),

                if (_currentRoom == 3 && !_pickedRoom3Item)
                  ElevatedButton(
                    onPressed: _pickUpItemInCurrentRoom,
                    child: const Text('Pick up Blazing Torch'),
                  ),

                if (_currentRoom == 4 && !_pickedRoom4Item)
                  ElevatedButton(
                    onPressed: _pickUpItemInCurrentRoom,
                    child: const Text('Pick up Throwing Spear'),
                  ),

                if (_currentRoom == 5 && !_pickedRoom5Item)
                  ElevatedButton(
                    onPressed: _pickUpItemInCurrentRoom,
                    child: const Text('Pick up Ancient Scroll'),
                  ),

                const SizedBox(height: 12),

                // Direction buttons (for movement) for the current room
                ...buttons,
              ],
            ),
          ),

          // EXIT GAME BUTTON:
          // This is separate from the game logic (because it's in bottomNavigationBar
          // It always shows at the bottom of the screen
          // It calls SystemNavigator.pop(), which tells Flutter to close the app.
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(12.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.indigo[500],
                side: BorderSide(color: Colors.indigo.shade300, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                SystemNavigator.pop();  //closes the app
              },
              child: const Text('Exit Game',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }

  }

