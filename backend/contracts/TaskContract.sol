// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// in solidity we use contract eg.we use main functions in JS but contract here!
contract TaskContract {
  event Addtask(address recipient, uint taskId);
  event Deletetask(uint taskId, bool isDeleted);
  //every carry-forward function is event in solidity
  //just mention the type of prop in solidity
  

  //we have to create a structure that will show us the table kinda thing which we need as a database. So struct here in solidity.
  //Below task is reference, what we want as a structure
  //Task = { id: 0, taskText: "Hello", isDeleted: false }
  struct Task {
    uint id;
    string taskText;
    bool isDeleted;
  }
  //here, structure needs keys to formulate.Mentioned in {}. Keys with its datatype.
  //Calling the struct is almost like constructor that we're calling. Eg,
  //Task(0, "Hello", false)
  

  //Now this is array name "tasks", which will be filled with tasks.
  //in solidity array looks like Type(here we want it like struct, Task),[](as array, __space__, access type for array, "nameofour array") 
  Task[] private tasks;
  mapping(uint256 => address) taskToOwner;
  //map which will help the owner
  //here we're saying initialize variable task to owner and type is gonna be.....(mentioned at the start)
  //here address is address of wallet and uint is id

  
  //sometimes we write memory with string that's it.
  //we can set memory to only public/external function arguments
  //external means we can access it from outside too.
  //msg.sender is in solidity will give us the address of whoever is logged in
  //An event is emitted, means it stores the arguments passed in transaction logs
  function addTask(string memory taskText, bool isDeleted) external {
    uint taskId = tasks.length;
    tasks.push(Task(taskId, taskText, isDeleted));
    taskToOwner[taskId] = msg.sender;
    emit Addtask(msg.sender, taskId);
  }

  //here we want tasks which are mine and not deleted
  function getMyTasks() external view returns (Task[] memory) {
    Task[] memory temp = new Task[](tasks.length);
    uint counter = 0;

    for (uint i=0; i<tasks.length; i++){
      if(taskToOwner[i] == msg.sender && tasks[i].isDeleted == false) {
        temp[counter] = tasks[i];
        counter++;
      }
    }
    Task[] memory result = new Task[](counter);
    for (uint i=0; i < counter; i++) {
      result[i] = temp[i];
    }
    return result;
  }

  function deleteTask(uint taskId, bool isDeleted) external {
    if(taskToOwner[taskId] == msg.sender) {
      tasks[taskId].isDeleted = isDeleted;
      emit Deletetask(taskId, isDeleted);
    }
  }

  
}
