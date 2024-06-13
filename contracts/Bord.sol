// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Bord is Ownable(msg.sender) {

    struct Task {
        uint256 taskId;
        address asker;
        address doer;
        string title;
        string content;
        uint256 reward;
        uint256 dateTimeCreated;
        uint256 dateTimeAccepted;
        uint256 timeLimit;
        int status; // -1: Deleted, 0: Open, 1: Accepted, 2: Submitted, 3: Completed, 4: Claimable, 5: Failed, 6: Disputing
        uint256 viewPrice;
        string videoLink;
        uint256 voteId;
    }

    struct TaskVote {
        uint256 taskId;
        uint256 neededVotes;
        uint256 totalVotes;
        uint256 successVotes;
        uint256 failVotes;
    }
    
    struct VoteStatus {
        uint256 totalVotes;
        uint256 neededVotes;
    }

    BordToken public bordToken;

    Task[] private tasks;
    uint256 taskCounter;
    TaskVote[] private taskVotes;
    uint256 voteCounter;

    uint256 editTaskPrice;
    uint256 deleteTaskPrice;
    uint256 dropDoerPrice;
    uint256 votePrice;
    // uint256 viewTaskPrice;

    constructor(address _BordTokenAddress) {
        bordToken =  BordToken(_BordTokenAddress);

        editTaskPrice = 1 * 10**bordToken.decimals();
        deleteTaskPrice = 1 * 10**bordToken.decimals();
        dropDoerPrice = 1 * 10**bordToken.decimals();
        votePrice = 1 * 10**bordToken.decimals();
        // viewTaskPrice = 1 * 10**bordToken.decimals();

        taskCounter = 0;
        voteCounter = 0;
    }

    function createTask(string memory _title, string memory _content, uint256 _reward, uint256 _timeLimit) public {
        // Check if the reward is >= 3 BRD Tokens
        require(_reward >= 3);
        
        // Check if the reward an odd amount
        require(_reward%2 == 1);

        // Check if the user has enough BRD Tokens
        require(bordToken.balanceOf(msg.sender) >= _reward*10**bordToken.decimals());

        (bool sent) = bordToken.transferFrom(msg.sender, address(this), _reward*10**bordToken.decimals());
        require(sent);

        Task memory newTask;

        newTask.taskId = taskCounter;
        newTask.asker = msg.sender;
        newTask.doer = address(0);
        newTask.title = _title;
        newTask.content = _content;
        newTask.reward = _reward;
        newTask.dateTimeCreated = block.timestamp;
        newTask.timeLimit = _timeLimit;
        newTask.status = 0;
        // newTask.viewPrice = viewTaskPrice;
        newTask.videoLink = "";

        tasks.push(newTask);
        taskCounter += 1;
    }

    function acceptTask(uint256 _taskId) public {
        Task storage taskToAccept = tasks[_taskId];

        // Check if the task exists and has an open status
        require(taskToAccept.taskId <= taskCounter);
        require(taskToAccept.status == 0);

        // Check if the doer is the message sender and not the asker
        require(
            taskToAccept.doer == address(0) && taskToAccept.asker != msg.sender
        );
        taskToAccept.doer = msg.sender;

        // Set the task status to 1 (Accepted)
        taskToAccept.status = 1;

        // Set the task datetime accepted to current datetime
        taskToAccept.dateTimeAccepted = block.timestamp;
    }

    function editTask(uint256 _taskId, string memory _newTitle, string memory _newContent, uint256 _newTimeLimit) public {
        // Check if the user has enough BRD Tokens
        require(bordToken.balanceOf(msg.sender) >= editTaskPrice);

        (bool sent) = bordToken.transferFrom(msg.sender, address(this), editTaskPrice);
        require(sent);
        
        Task storage taskToEdit = tasks[_taskId];

        // Check if the task exists
        require(taskToEdit.taskId <= taskCounter);

        // Check if the asker is the message sender
        require(taskToEdit.asker == msg.sender);

        // Check if the task status is 0 (Open)
        require(taskToEdit.status == 0);

        // Apply edit
        taskToEdit.title = _newTitle;
        taskToEdit.content = _newContent;
        taskToEdit.timeLimit = _newTimeLimit;
    }

    function deleteTask(uint256 _taskId) public {
        // Check if the user has enough BRD Tokens
        require(bordToken.balanceOf(msg.sender) >= deleteTaskPrice);

        (bool sent) = bordToken.transferFrom(msg.sender, address(this), deleteTaskPrice);
        require(sent);

        Task storage taskToDelete = tasks[_taskId];

        // Check if the task exists
        require(taskToDelete.taskId <= taskCounter);

        // Check if the asker is the message sender
        require(taskToDelete.asker == msg.sender);

        // Check if the task status is 0 (Open)
        require(taskToDelete.status == 0);

        // Set the task status to -1 (Deleted)
        taskToDelete.status = -1;
    }

    function submitTask(uint256 _taskId, string memory _videoLink) public {
        Task storage taskToSubmit = tasks[_taskId];

        // Check if the task exists
        require(taskToSubmit.taskId <= taskCounter);

        // Check if the task status is 1 (Accepted)
        require(
            taskToSubmit.status == 1);

        // Check if the doer is the message sender
        require(
            taskToSubmit.doer == msg.sender);

        // Set the task status to 2 (Submitted)
        taskToSubmit.status = 2;
        taskToSubmit.videoLink = _videoLink;
        // taskToSubmit.viewPrice = _viewPrice;
    }

    function passTask(uint256 _taskId) public {
        Task storage taskToPass = tasks[_taskId];

        // Check if the task exists
        require(taskToPass.taskId <= taskCounter);

        // Check if the asker is the message sender
        require(taskToPass.asker == msg.sender);

        // Check if the task status is 2 (Submitted)
        require(taskToPass.status == 2);

        // Set the task status to 4 (Claimable)
        taskToPass.status = 4;
    }

    function failTask(uint256 _taskId) public {
        Task storage taskToFail = tasks[_taskId];

        // Check if the task exists
        require(taskToFail.taskId <= taskCounter);

        // Check if the asker is the message sender
        require(taskToFail.asker == msg.sender);

        // Check if the task status is 2 (Submitted)
        require(taskToFail.status == 2);

        // Set the task status to 5 (Failed)
        taskToFail.status = 5;
    }

    function abandonTask(uint256 _taskId) public {
        Task storage taskToAbandon = tasks[_taskId];

        // Check if the task exists
        require(taskToAbandon.taskId <= taskCounter);

        // Check if the doer is the message sender
        require(
            taskToAbandon.doer == msg.sender);

        // Check if the task status is 1 (Accepted) or 5 (Failed)
        require(
            taskToAbandon.status == 1 || taskToAbandon.status == 5);

        // Set the task status to 0 (Open)
        taskToAbandon.status = 0;
        taskToAbandon.doer = address(0);
    }

    function disputeTask(uint256 _taskId) public {
        Task storage taskToDispute = tasks[_taskId];

        // Check if the task exists
        require(taskToDispute.taskId <= taskCounter);

        // Check if the doer is the message sender
        require(
            taskToDispute.doer == msg.sender);

        // Check if the task status is 5 (Failed)
        require(
            taskToDispute.status == 5);

        // Set the task status to 6 (Disputing)
        taskToDispute.status = 6;
        taskToDispute.voteId = voteCounter;
        voteCounter++;

        // Create new TaskVote
        TaskVote memory newTaskVote;

        newTaskVote.taskId = taskToDispute.taskId;
        newTaskVote.neededVotes = taskToDispute.reward;
        newTaskVote.totalVotes = 0;
        newTaskVote.successVotes = 0;
        newTaskVote.failVotes = 0;
        
        taskVotes.push(newTaskVote);
    }

    function claimReward(uint256 _taskId) public {
        Task storage taskToClaimReward = tasks[_taskId];

        // Check if the task exists
        require(taskToClaimReward.taskId <= taskCounter);

        // Check if the doer is the message sender
        require(
            taskToClaimReward.doer == msg.sender);

        // Check if the task status is 4 (Claimable)
        require(
            taskToClaimReward.status == 4);

        // Set the task status to 3 (Completed)
        taskToClaimReward.status = 3;

        // Check if the user has enough BRD Tokens
        require(bordToken.balanceOf(address(this)) >= taskToClaimReward.reward*10**bordToken.decimals());

        // Transfer the reward to the doer
        (bool sent) = bordToken.transfer(msg.sender, taskToClaimReward.reward*10**bordToken.decimals());
        require(sent);
    }

    function dropDoerAfterTimeLimit(uint256 _taskId) public {
        Task storage taskToDrop = tasks[_taskId];

        // Check if the task exists
        require(taskToDrop.taskId <= taskCounter);

        // Check if the asker is the message sender
        require(taskToDrop.asker == msg.sender);

        // Check if the task status is 1 (Accepted)
        require(taskToDrop.status == 1);

        // Check if the current date time is after the time limit from date time accepted
        require(block.timestamp - taskToDrop.dateTimeAccepted > taskToDrop.timeLimit);

        // Drop doer
        taskToDrop.doer = address(0);
        taskToDrop.status = 0;
    }

    function dropDoerBeforeTimeLimit(uint256 _taskId) public {
        Task storage taskToDrop = tasks[_taskId];

        // Check if the task exists
        require(taskToDrop.taskId <= taskCounter);

        // Check if the asker is the message sender
        require(taskToDrop.asker == msg.sender);

        // Check if the task status is 1 (Accepted)
        require(taskToDrop.status == 1);

        // Check if the current date time is within the time limit from date time accepted
        require(block.timestamp - taskToDrop.dateTimeAccepted <= taskToDrop.timeLimit);

        // Check if the user has enough BRD Tokens
        require(bordToken.balanceOf(msg.sender) >= dropDoerPrice);

        (bool sent) = bordToken.transferFrom(msg.sender, address(this), dropDoerPrice);
        require(sent);

        // Drop doer
        taskToDrop.doer = address(0);
        taskToDrop.status = 0;
    }

    function voteSucceedTask(uint256 _taskId) public {
        Task storage taskToVoteSucceed = tasks[_taskId];
        
        // Check if the task exists
        require(taskToVoteSucceed.taskId <= taskCounter);

        // Check if the asker or the doer is the message sender
        require(taskToVoteSucceed.asker != msg.sender && taskToVoteSucceed.doer != msg.sender);

        // Check if the task status is 6 (Disputing)
        require(taskToVoteSucceed.status == 6);

        // Vote Succeed
        TaskVote storage taskVote = taskVotes[taskToVoteSucceed.voteId];

        // Check if the total votes is less than the needed votes
        require(taskVote.totalVotes < taskVote.neededVotes);

        // Check if the user has enough BRD Tokens
        require(bordToken.balanceOf(msg.sender) >= votePrice);

        (bool sent) = bordToken.transferFrom(msg.sender, address(this), votePrice);
        require(sent);
    
        taskVote.totalVotes++;
        taskVote.successVotes++;

        // Check if the total votes is equal to the needed votes
        if (taskVote.totalVotes == taskVote.neededVotes) {
            // Check the results
            if (taskVote.successVotes > taskVote.failVotes) {   // Task succeeded
                taskToVoteSucceed.status = 4;   // Make task Claimable
            }
            else {  // Task Failed
                taskToVoteSucceed.status = 0;   // Make task Open
                taskToVoteSucceed.videoLink = "";
            }
        }
    }

    function voteFailTask(uint256 _taskId) public {
        Task storage taskToVoteFail = tasks[_taskId];
        
        // Check if the task exists
        require(taskToVoteFail.taskId <= taskCounter);

        // Check if the asker or the doer is the message sender
        require(taskToVoteFail.asker != msg.sender && taskToVoteFail.doer != msg.sender);

        // Check if the task status is 6 (Disputing)
        require(taskToVoteFail.status == 6);

        // Vote Fail
        TaskVote storage taskVote = taskVotes[taskToVoteFail.voteId];

        // Check if the total votes is less than the needed votes
        require(taskVote.totalVotes < taskVote.neededVotes);

        // Check if the user has enough BRD Tokens
        require(bordToken.balanceOf(msg.sender) >= votePrice);

        (bool sent) = bordToken.transferFrom(msg.sender, address(this), votePrice);
        require(sent);
    
        taskVote.totalVotes++;
        taskVote.failVotes++;

        // Check if the total votes is equal to the needed votes
        if (taskVote.totalVotes == taskVote.neededVotes) {
            // Check the results
            if (taskVote.failVotes > taskVote.successVotes) {   // Task Failed
                taskToVoteFail.status = 0;   // Make task Open
                taskToVoteFail.videoLink = "";
            }
            else {  // Task Succeeded
                taskToVoteFail.status = 4;   // Make task Claimable
            }
        }
    }

    function getAllTasks() public view returns (Task[] memory) {
        return tasks;
    }

    function getTasksByAsker() public view returns (Task[] memory) {
        Task[] memory filteredTasks = new Task[](tasks.length);
        uint256 filteredCounter = 0;

        for (uint256 i = 0; i < tasks.length; i++) {
            if (tasks[i].asker == msg.sender) {
                filteredTasks[filteredCounter] = tasks[i];
                filteredCounter++;
            }
        }

        Task[] memory result = new Task[](filteredCounter);
        for (uint256 i = 0; i < filteredCounter; i++) {
            result[i] = filteredTasks[i];
        }

        return result;
    }

    function getTasksByDoer() public view returns (Task[] memory) {
        Task[] memory filteredTasks = new Task[](tasks.length);
        uint256 filteredCounter = 0;

        for (uint256 i = 0; i < tasks.length; i++) {
            if (tasks[i].doer == msg.sender) {
                filteredTasks[filteredCounter] = tasks[i];
                filteredCounter++;
            }
        }

        Task[] memory result = new Task[](filteredCounter);
        for (uint256 i = 0; i < filteredCounter; i++) {
            result[i] = filteredTasks[i];
        }

        return result;
    }

    function getOpenTasks() public view returns (Task[] memory) {
        Task[] memory filteredTasks = new Task[](tasks.length);
        uint256 filteredCounter = 0;

        for (uint256 i = 0; i < tasks.length; i++) {
            if (tasks[i].status == 0) {
                filteredTasks[filteredCounter] = tasks[i];
                filteredCounter++;
            }
        }

        Task[] memory result = new Task[](filteredCounter);
        for (uint256 i = 0; i < filteredCounter; i++) {
            result[i] = filteredTasks[i];
        }

        return result;
    }

    function getTaskVoteStatus(uint256 _taskId) public view returns (VoteStatus memory) {
        VoteStatus memory voteStatus;

        for (uint256 i = 0; i < taskVotes.length; i++) {
            if (taskVotes[i].taskId == _taskId) {
                voteStatus.totalVotes = taskVotes[i].totalVotes;
                voteStatus.neededVotes = taskVotes[i].neededVotes;
            }
        }

        return voteStatus;
    }

}


////
contract BordToken is ERC20("Bord Token", "BRD"), Ownable(msg.sender) {

    uint public tokenBuyPrice = 0.00050 ether;
    uint public tokenSellPrice = 0.00045 ether;


    function setTokenBuyPrice(uint256 _newTokenBuyPrice) public onlyOwner {
        tokenBuyPrice = _newTokenBuyPrice;
    }
    function setTokenSellPrice(uint256 _newTokenSellPrice) public onlyOwner {
        tokenSellPrice = _newTokenSellPrice;
    }
    function resetTokenBuyPrice() public onlyOwner {
        tokenBuyPrice = 0.00050 ether;
    }
    function resetTokenSellPrice() public onlyOwner {
        tokenSellPrice = 0.00045 ether;
    }

    function myBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function mint(address to, uint256 amount) private {
        _mint(to, amount);
    }

    function buyTokens(uint amount) public payable {
        require(msg.value >= tokenBuyPrice * amount);
        // Transfer token to the msg.sender
        mint(msg.sender, amount * 10 ** decimals());
    }

    function sellTokens(uint256 amount) public {
        require(amount > 0);
        require(balanceOf(msg.sender) >= amount);

        // Calculate the amount of ether to transfer to the seller
        uint256 etherAmount = amount * tokenSellPrice;

        // Burn the tokens sold
        _burn(msg.sender, amount * 10 ** decimals());

        // Transfer ether to the seller
        (bool success, ) = msg.sender.call{value: etherAmount}("");
        require(success);
    }

    function withdrawBalance() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
////