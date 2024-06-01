// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract Bord is Ownable(msg.sender) {
    // ERC20 public BordToken;

    // 0.0001 ETH <-> 0.36 USD
    // 0.0001 ETH <-> 1 BRD

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
    }

    struct Votes {
        uint256 taskId;
        uint256 totalVotes;
        uint256 successVotes;
        uint256 failVotes;
    }

    BordToken public bordToken;

    Task[] private tasks;
    uint256 taskCounter;

    uint256 editTaskPrice;
    uint256 deleteTaskPrice;
    uint256 dropDoerPrice;
    uint256 votePrice;

    // Dummy Data Start
    address[] dummyTaskAskers = [
        address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
        address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
        address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
        address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
        address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
        address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
        address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
        address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
        address(0x91505F2a1C83F6f404628494c2b79603CDc106C9),
        address(0x91505F2a1C83F6f404628494c2b79603CDc106C9),
        address(0x91505F2a1C83F6f404628494c2b79603CDc106C9),
        address(0x91505F2a1C83F6f404628494c2b79603CDc106C9),
        address(0x91505F2a1C83F6f404628494c2b79603CDc106C9),
        address(0x91505F2a1C83F6f404628494c2b79603CDc106C9),
        address(0x91505F2a1C83F6f404628494c2b79603CDc106C9),
        address(0x91505F2a1C83F6f404628494c2b79603CDc106C9),
        address(0x6E4A412739ADA24031C92E75B0CEA26aFD2FbE0C),
        address(0x6E4A412739ADA24031C92E75B0CEA26aFD2FbE0C),
        address(0x6E4A412739ADA24031C92E75B0CEA26aFD2FbE0C),
        address(0x6E4A412739ADA24031C92E75B0CEA26aFD2FbE0C),
        address(0x6E4A412739ADA24031C92E75B0CEA26aFD2FbE0C),
        address(0x6E4A412739ADA24031C92E75B0CEA26aFD2FbE0C),
        address(0x6E4A412739ADA24031C92E75B0CEA26aFD2FbE0C),
        address(0x6E4A412739ADA24031C92E75B0CEA26aFD2FbE0C)
    ];
    string[] dummyTaskTitles = [
        "Write a Short Story",
        "Design a Logo",
        "Solve Math Problems",
        "Translate Document",
        "Create a Recipe",
        "Code Review",
        "Digital Art Creation",
        "Edit Video",
        "Graphic Design for Website",
        "Write SEO Article",
        "Transcribe Audio",
        "Data Entry for Excel Sheet",
        "Create Social Media Posts",
        "Proofread Document",
        "Voiceover for Ad",
        "Website Development",
        "Translate Website Content",
        "Design Product Packaging",
        "Logo Animation",
        "Create Infographic",
        "Edit Podcast Episode",
        "Illustrate Children's Book",
        "Write Product Reviews",
        "Virtual Assistant Tasks"
    ];
    string[] dummyTaskContents = [
        "Compose a fictional short story with a minimum of 500 words.",
        "Create a logo for a new tech startup company.",
        "Solve a set of 10 math problems ranging from algebra to calculus.",
        "Translate a 5-page document from English to Spanish.",
        "Develop a unique recipe for a vegan dessert.",
        "Review a Python codebase and provide feedback on optimization.",
        "Create a digital artwork inspired by nature.",
        "Edit a promotional video for a fitness brand.",
        "Design graphics for a new website layout.",
        "Write an SEO-optimized article on digital marketing trends.",
        "Transcribe a 30-minute audio file into text format.",
        "Enter data from scanned documents into an Excel sheet.",
        "Develop engaging social media posts for a fashion brand.",
        "Proofread a 20-page document for grammar and spelling errors.",
        "Record a voiceover for a 60-second advertisement.",
        "Develop a responsive website for a local business.",
        "Translate website content from English to French.",
        "Design packaging for a new line of beauty products.",
        "Create a dynamic animated logo for a tech startup.",
        "Design an infographic showcasing environmental statistics.",
        "Edit a 45-minute podcast episode for clarity and flow.",
        "Illustrate 10 pages of a children's storybook.",
        "Write authentic reviews for 5 different products.",
        "Assist with various administrative tasks such as scheduling and email management."
    ];
    uint256[] dummyTaskRewards = [
        5,
        10,
        3,
        15,
        8,
        12,
        20,
        25,
        18,
        7,
        4,
        12,
        10,
        6,
        15,
        30,
        20,
        25,
        10,
        8,
        14,
        22,
        5,
        20
    ];
    uint256[] dummyTaskDateTimesCreated = [
        1678934642,
        1678935945,
        1678937218,
        1678938502,
        1678939756,
        1678941034,
        1678942379,
        1678943658,
        1678944965,
        1678946278,
        1678947563,
        1678948821,
        1678950098,
        1678951392,
        1678952654,
        1678953942,
        1678955219,
        1678956487,
        1678957776,
        1678959054,
        1678960352,
        1678961605,
        1678962892,
        1678964157
    ];
    uint256[] dummyTaskTimeLimits = [
        604800,
        86400,
        172800,
        259200,
        432000,
        345600,
        604800,
        864000,
        691200,
        172800,
        86400,
        345600,
        259200,
        129600,
        604800,
        1209600,
        604800,
        864000,
        172800,
        259200,
        432000,
        691200,
        172800,
        345600
    ];


    constructor(address _BordTokenAddress) {
        bordToken =  BordToken(_BordTokenAddress);

        editTaskPrice = 1 * 10**bordToken.decimals();
        deleteTaskPrice = 1 * 10**bordToken.decimals();
        dropDoerPrice = 1 * 10**bordToken.decimals();
        votePrice = 1 * 10**bordToken.decimals();

        taskCounter = 0;

        // Initialize dummy tasks
        for (uint256 i = 0; i < 24; i++) {
            Task memory newTask;

            newTask.taskId = i;
            newTask.asker = dummyTaskAskers[i];
            newTask.doer = address(0);
            newTask.title = dummyTaskTitles[i];
            newTask.content = dummyTaskContents[i];
            newTask.reward = dummyTaskRewards[i];
            newTask.dateTimeCreated = dummyTaskDateTimesCreated[i];
            newTask.timeLimit = dummyTaskTimeLimits[i];
            newTask.status = 0;
            newTask.viewPrice = 0;
            newTask.videoLink = "";

            tasks.push(newTask);
            taskCounter += 1;
        }
    }

    function createTask(string memory _title, string memory _content, uint256 _reward, uint256 _timeLimit) public {
        // Check if the reward is >= 3 BRD Tokens
        require(_reward >= 3, "Reward must be greater than or equal to 3 BRD");
        
        // Check if the reward an odd amount
        require(_reward%2 == 1, "Reward must be an odd amount");

        // Check if the user has enough BRD Tokens
        require(bordToken.balanceOf(msg.sender) >= _reward*10**bordToken.decimals(), "Insufficient token balance");

        (bool sent) = bordToken.transferFrom(msg.sender, address(this), _reward*10**bordToken.decimals());
        require(sent, "Failed to transfer tokens from user to bord");

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
        newTask.viewPrice = 0;
        newTask.videoLink = "";

        tasks.push(newTask);
        taskCounter += 1;
    }

    function acceptTask(uint256 _taskId) public {
        Task storage taskToAccept = tasks[_taskId];

        // Check if the task exists and has an open status
        require(taskToAccept.taskId <= taskCounter, "Task does not exist");
        require(taskToAccept.status == 0, "Task is not open");

        // Check if the doer is the message sender and not the asker
        require(
            taskToAccept.doer == address(0) && taskToAccept.asker != msg.sender,
            "Task is already accepted by another DOER or the asker cannot accept their own task"
        );
        taskToAccept.doer = msg.sender;

        // Set the task status to 1 (Accepted)
        taskToAccept.status = 1;

        // Set the task datetime accepted to current datetime
        taskToAccept.dateTimeAccepted = block.timestamp;
    }

    function editTask(uint256 _taskId, string memory _newTitle, string memory _newContent, uint256 _newReward, uint256 _newTimeLimit) public {
        // Check if the reward is >= 3 BRD Tokens
        require(_newReward >= 3, "Reward must be greater than or equal to 3 BRD");
        
        // Check if the reward an odd amount
        require(_newReward%2 == 1, "Reward must be an odd amount");

        // Check if the user has enough BRD Tokens
        require(bordToken.balanceOf(msg.sender) >= editTaskPrice, "Insufficient token balance");

        (bool sent) = bordToken.transferFrom(msg.sender, address(this), editTaskPrice);
        require(sent, "Failed to transfer tokens from user to bord");
        
        Task storage taskToEdit = tasks[_taskId];

        // Check if the task exists
        require(taskToEdit.taskId <= taskCounter, "Task does not exist");

        // Check if the asker is the message sender
        require(taskToEdit.asker == msg.sender, "Only the asker can edit the task");

        // Check if the task status is 0 (Open)
        require(taskToEdit.status == 0, "Task is not open for editing");

        // Apply edit
        taskToEdit.title = _newTitle;
        taskToEdit.content = _newContent;
        taskToEdit.reward = _newReward;
        taskToEdit.timeLimit = _newTimeLimit;
    }

    function deleteTask(uint256 _taskId) public {
        // Check if the user has enough BRD Tokens
        require(bordToken.balanceOf(msg.sender) >= deleteTaskPrice, "Insufficient token balance");

        (bool sent) = bordToken.transferFrom(msg.sender, address(this), deleteTaskPrice);
        require(sent, "Failed to transfer tokens from user to bord");

        Task storage taskToDelete = tasks[_taskId];

        // Check if the task exists
        require(taskToDelete.taskId <= taskCounter, "Task does not exist");

        // Check if the asker is the message sender
        require(taskToDelete.asker == msg.sender, "Only the asker can delete the task");

        // Check if the task status is 0 (Open)
        require(taskToDelete.status == 0, "Task is not open for deletion");

        // Set the task status to -1 (Deleted)
        taskToDelete.status = -1;
    }

    function submitTask(uint256 _taskId, string memory _videoLink, uint256 _viewPrice) public {
        Task storage taskToSubmit = tasks[_taskId];

        // Check if the task exists
        require(taskToSubmit.taskId <= taskCounter, "Task does not exist");

        // Check if the task status is 1 (Accepted)
        require(
            taskToSubmit.status == 1,
            "Task is not accepted for submission"
        );

        // Check if the doer is the message sender
        require(
            taskToSubmit.doer == msg.sender,
            "Only the doer can submit the task"
        );

        // Set the task status to 2 (Submitted)
        taskToSubmit.status = 2;
        taskToSubmit.videoLink = _videoLink;
        taskToSubmit.viewPrice = _viewPrice;
    }

    function passTask(uint256 _taskId) public {
        Task storage taskToPass = tasks[_taskId];

        // Check if the task exists
        require(taskToPass.taskId <= taskCounter, "Task does not exist");

        // Check if the asker is the message sender
        require(taskToPass.asker == msg.sender, "Only the asker can pass the task");

        // Check if the task status is 2 (Submitted)
        require(taskToPass.status == 2, "Unable to pass task. Task is not submitted yet.");

        // Set the task status to 4 (Claimable)
        taskToPass.status = 4;
    }

    function failTask(uint256 _taskId) public {
        Task storage taskToFail = tasks[_taskId];

        // Check if the task exists
        require(taskToFail.taskId <= taskCounter, "Task does not exist");

        // Check if the asker is the message sender
        require(taskToFail.asker == msg.sender, "Only the asker can pass the task");

        // Check if the task status is 2 (Submitted)
        require(taskToFail.status == 2, "Unable to fail task. Task is not submitted yet.");

        // Set the task status to 5 (Failed)
        taskToFail.status = 5;
    }

    function abandonTask(uint256 _taskId) public {
        Task storage taskToAbandon = tasks[_taskId];

        // Check if the task exists
        require(taskToAbandon.taskId <= taskCounter, "Task does not exist");

        // Check if the doer is the message sender
        require(
            taskToAbandon.doer == msg.sender,
            "Only the doer can abandon the task"
        );

        // Check if the task status is 1 (Accepted)
        require(
            taskToAbandon.status == 1,
            "Task is not accepted for abandonment"
        );

        // Set the task status to 0 (Open)
        taskToAbandon.status = 0;
        taskToAbandon.doer = address(0);
    }

    function disputeTask(uint256 _taskId) public {
        Task storage taskToDispute = tasks[_taskId];

        // Check if the task exists
        require(taskToDispute.taskId <= taskCounter, "Task does not exist");

        // Check if the doer is the message sender
        require(
            taskToDispute.doer == msg.sender,
            "Only the doer can dispute the task"
        );

        // Check if the task status is 5 (Failed)
        require(
            taskToDispute.status == 5,
            "Task is not failed for abandonment"
        );

        // Set the task status to 6 (Disputing)
        taskToDispute.status = 6;
    }

    function claimReward(uint256 _taskId) public {
        Task storage taskToClaimReward = tasks[_taskId];

        // Check if the task exists
        require(taskToClaimReward.taskId <= taskCounter, "Task does not exist");

        // Check if the doer is the message sender
        require(
            taskToClaimReward.doer == msg.sender,
            "Only the doer can claim the reward from the task"
        );

        // Check if the task status is 4 (Claimable)
        require(
            taskToClaimReward.status == 4,
            "Task is not claimable for claiming"
        );

        // Set the task status to 3 (Completed)
        taskToClaimReward.status = 3;

        // Check if the user has enough BRD Tokens
        require(bordToken.balanceOf(address(this)) >= taskToClaimReward.reward*10**bordToken.decimals(), "Insufficient token balance");

        // Transfer the reward to the doer
        (bool sent) = bordToken.transfer(msg.sender, taskToClaimReward.reward*10**bordToken.decimals());
        require(sent, "Failed to transfer tokens from bord to user");
    }

    function dropDoerBeforeTimeLimit(uint256 _taskId) public {
        Task storage taskToDrop = tasks[_taskId];

        // Check if the task exists
        require(taskToDrop.taskId <= taskCounter, "Task does not exist");

        // Check if the asker is the message sender
        require(taskToDrop.asker == msg.sender, "Only the asker can drop the doer");

        // Check if the task status is 1 (Accepted)
        require(taskToDrop.status == 1, "Task is not accepted for dropping doer");

        // Check if the current date time is within the time limit from date created
        require(block.timestamp - taskToDrop.dateTimeCreated <= taskToDrop.timeLimit, "Time limit has passed");

        // Drop doer
        taskToDrop.doer = address(0);
        taskToDrop.status = 0;
    }

    function dropDoerAfterTimeLimit(uint256 _taskId) public {
        Task storage taskToDrop = tasks[_taskId];

        // Check if the task exists
        require(taskToDrop.taskId <= taskCounter, "Task does not exist");

        // Check if the asker is the message sender
        require(taskToDrop.asker == msg.sender, "Only the asker can drop the doer");

        // Check if the task status is 1 (Accepted)
        require(taskToDrop.status == 1, "Task is not accepted for dropping doer");

        // Check if the current date time is after the time limit from date created
        require(block.timestamp - taskToDrop.dateTimeCreated > taskToDrop.timeLimit, "Time limit has not passed");

        // Check if the user has enough BRD Tokens
        require(bordToken.balanceOf(msg.sender) >= dropDoerPrice, "Insufficient token balance");

        (bool sent) = bordToken.transferFrom(msg.sender, address(this), dropDoerPrice);
        require(sent, "Failed to transfer tokens from user to bord");

        // Drop doer
        taskToDrop.doer = address(0);
        taskToDrop.status = 0;
    }

    function getTask(uint256 _taskId) public view returns (Task memory) {
        for (uint256 i = 0; i < tasks.length; i++) {
            if (tasks[i].taskId == _taskId) {
                return tasks[i];
            }
        }

        // If no task is found, return an empty Task struct
        Task memory emptyTask;
        return emptyTask;
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

}


////
contract BordToken is ERC20("Bord Token", "BRD"), ERC20Burnable, Ownable(msg.sender) {

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

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function buyTokens(uint amount) public payable {
        require(msg.value >= tokenBuyPrice * amount, "Insufficient funds");
        // Transfer token to the msg.sender
        mint(msg.sender, amount * 10 ** decimals());
    }

    event ContractBalance(uint256 balance);
    function sellTokens(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Insufficient token balance");

        // Calculate the amount of ether to transfer to the seller
        uint256 etherAmount = amount * tokenSellPrice;

        // Burn the tokens sold
        _burn(msg.sender, amount * 10 ** decimals());

        // Emit the contract balance
        emit ContractBalance(address(this).balance);

        // Transfer ether to the seller
        (bool success, ) = msg.sender.call{value: etherAmount}("");
        require(success, "Transfer failed");

        // Emit the contract balance
        emit ContractBalance(address(this).balance);
    }
}
////