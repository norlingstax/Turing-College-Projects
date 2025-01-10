# Module 4, Sprint 1: First Steps Into Programming

This project focused on introducing fundamental programming concepts through two engaging tasks: building a **Tic-Tac-Toe game** and a program to simulate a **chessboard capture scenario**. The sprint provided hands-on experience in Python programming and problem-solving, laying the foundation for more advanced analytical workflows.

---

## 📋 Project Overview

### Objectives
1. **Hands-On Task: Tic-Tac-Toe Game**:
   - Build a console-based game where the user competes against the computer.
   - Implement randomised computer moves and determine game outcomes based on winning conditions.
   - Design an interactive experience with a clearly displayed game grid.

2. **Graded Task: Chessboard Capture Simulation**:
   - Simulate a chessboard with one white piece and multiple black pieces.
   - Determine which black pieces can be captured by the white piece in one move based on chess rules.
   - Validate user inputs and dynamically update the board state for each piece added.

---

## 🛠️ Key Skills Acquired

### Core Programming Concepts
- **Control Flow**:
  - Used `while` and `for` loops to implement game mechanics and iterative logic.
  - Applied `if-elif-else` conditions to handle user inputs, validate moves, and check winning or capture conditions.

- **Data Structures**:
  - Utilised **dictionaries** to represent the game grid and chessboard, allowing dynamic updates and efficient data retrieval.
  - Used **lists** to store valid moves, user inputs, and available positions.

- **Functions**:
  - Encapsulated repetitive tasks (e.g., grid updates, board printing, move calculations) into reusable functions, promoting clean and modular code.

- **Input Validation**:
  - Implemented robust input validation to ensure the correctness of user inputs and handle edge cases effectively.

- **Logical Problem Solving**:
  - Designed algorithms to calculate winning conditions in Tic-Tac-Toe.
  - Developed chess-specific move logic for knights and rooks, accounting for board boundaries and obstacles.

### Programming for Data Analysis
The skills gained in this sprint directly translate to data analysis tasks:
- **Data Validation**:
  - Input validation techniques are crucial when cleaning and preprocessing datasets.
  - Ensuring data integrity prevents errors in downstream analyses.

- **Dynamic Data Structures**:
  - Using dictionaries and lists for representing grids is analogous to working with tabular data in Python libraries like `pandas`.

- **Algorithm Design**:
  - Chess move logic mirrors the complexity of designing SQL queries or custom functions for data manipulation.

- **Iterative Processing**:
  - Loops and conditional logic are fundamental when working with large datasets, such as filtering rows, applying transformations, or creating new calculated fields.

---

## 🎮 Hands-On Task: Tic-Tac-Toe Game

### Key Features
1. **Interactive Gameplay**:
   - The user always starts, entering moves in a `x, y` format.
   - The computer plays randomly, with the game alternating between the user and computer until a win or tie occurs.

2. **Grid Representation**:
   - The grid is dynamically updated and displayed after every move, ensuring clarity.

3. **Winning Logic**:
   - The program checks for all possible winning combinations (rows, columns, diagonals).

### Concepts Demonstrated
- Randomisation (`random.choice`) for computer moves.
- Nested data structures (grid as a dictionary).
- Loop-driven input prompts with validation.

---

## ♟ Graded Task: Chessboard Capture Simulation

### Key Features
1. **User Interaction**:
   - The user places one white piece (`knight` or `rook`) and up to 16 black pieces on a chessboard.
   - Input validation ensures correct formats (`piece position`) and prevents invalid moves.

2. **Chess Move Logic**:
   - For knights: L-shaped moves are calculated programmatically.
   - For rooks: Horizontal and vertical moves are dynamically determined, stopping at obstacles.

3. **Capture Determination**:
   - The program identifies which black pieces can be captured by the white piece in a single move.

4. **Dynamic Board Updates**:
   - A dictionary-based board is updated after each input, with visual output reflecting the current state.

### Concepts Demonstrated
- Modular design using functions for key tasks (e.g., `get_knight_moves`, `get_rook_moves`, `print_board`).
- Logical problem-solving for chess-specific rules.
- String manipulation and indexing for position parsing.

---

## 🌟 Key Takeaways
This sprint enhanced my ability to:
- Apply core programming concepts in solving practical problems.
- Translate real-world challenges into structured programs.
- Develop logic that can directly benefit data analysis workflows.
