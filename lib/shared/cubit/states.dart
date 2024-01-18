//this class use to make one object in cubit.
abstract class TodoStates {}

// this state use in Creation of app.
class TodoInitialState extends TodoStates {}

// this state use in Navigate between Tabs in bottom navigation bar.
class TodoChangeBottomNavBarState extends TodoStates {}

// this state use in Navigate between States in bottom Sheet.
class TodoChangeBottomSheetState extends TodoStates {}

// this state use in Initialization of database.
class TodoCreateDatabaseState extends TodoStates {}

// this state use in Get data from database.
class TodoGetDatabaseState extends TodoStates {}

// this state use in Insert into database.
class TodoInsertDatabaseState extends TodoStates {}

// this state use in Insert into database.
class TodoUpdateDatabaseState extends TodoStates {}

// this state use in Delete from database.
class TodoDeleteDatabaseState extends TodoStates {}
