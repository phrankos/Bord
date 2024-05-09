// export const ABI = [
//   {
//     "inputs": [],
//     "stateMutability": "nonpayable",
//     "type": "constructor"
//   },
//   {
//     "inputs": [
//       {
//         "internalType": "string",
//         "name": "_title",
//         "type": "string"
//       },
//       {
//         "internalType": "string",
//         "name": "_content",
//         "type": "string"
//       },
//       {
//         "internalType": "uint256",
//         "name": "_prize",
//         "type": "uint256"
//       },
//       {
//         "internalType": "uint256",
//         "name": "_timeLimit",
//         "type": "uint256"
//       }
//     ],
//     "name": "createTask",
//     "outputs": [],
//     "stateMutability": "nonpayable",
//     "type": "function"
//   },
//   {
//     "inputs": [
//       {
//         "internalType": "uint256",
//         "name": "",
//         "type": "uint256"
//       }
//     ],
//     "name": "dummyTaskContents",
//     "outputs": [
//       {
//         "internalType": "string",
//         "name": "",
//         "type": "string"
//       }
//     ],
//     "stateMutability": "view",
//     "type": "function"
//   },
//   {
//     "inputs": [
//       {
//         "internalType": "uint256",
//         "name": "",
//         "type": "uint256"
//       }
//     ],
//     "name": "dummyTaskIds",
//     "outputs": [
//       {
//         "internalType": "uint256",
//         "name": "",
//         "type": "uint256"
//       }
//     ],
//     "stateMutability": "view",
//     "type": "function"
//   },
//   {
//     "inputs": [
//       {
//         "internalType": "uint256",
//         "name": "",
//         "type": "uint256"
//       }
//     ],
//     "name": "dummyTaskPrizes",
//     "outputs": [
//       {
//         "internalType": "uint256",
//         "name": "",
//         "type": "uint256"
//       }
//     ],
//     "stateMutability": "view",
//     "type": "function"
//   },
//   {
//     "inputs": [
//       {
//         "internalType": "uint256",
//         "name": "",
//         "type": "uint256"
//       }
//     ],
//     "name": "dummyTaskTimeLimits",
//     "outputs": [
//       {
//         "internalType": "uint256",
//         "name": "",
//         "type": "uint256"
//       }
//     ],
//     "stateMutability": "view",
//     "type": "function"
//   },
//   {
//     "inputs": [
//       {
//         "internalType": "uint256",
//         "name": "",
//         "type": "uint256"
//       }
//     ],
//     "name": "dummyTaskTitles",
//     "outputs": [
//       {
//         "internalType": "string",
//         "name": "",
//         "type": "string"
//       }
//     ],
//     "stateMutability": "view",
//     "type": "function"
//   },
//   {
//     "inputs": [],
//     "name": "getAllTasks",
//     "outputs": [
//       {
//         "components": [
//           {
//             "internalType": "uint256",
//             "name": "taskId",
//             "type": "uint256"
//           },
//           {
//             "internalType": "address",
//             "name": "asker",
//             "type": "address"
//           },
//           {
//             "internalType": "address",
//             "name": "doer",
//             "type": "address"
//           },
//           {
//             "internalType": "string",
//             "name": "title",
//             "type": "string"
//           },
//           {
//             "internalType": "string",
//             "name": "content",
//             "type": "string"
//           },
//           {
//             "internalType": "uint256",
//             "name": "prize",
//             "type": "uint256"
//           },
//           {
//             "internalType": "uint256",
//             "name": "dateTimeCreated",
//             "type": "uint256"
//           },
//           {
//             "internalType": "uint256",
//             "name": "timeLimit",
//             "type": "uint256"
//           },
//           {
//             "internalType": "int256",
//             "name": "status",
//             "type": "int256"
//           },
//           {
//             "internalType": "string",
//             "name": "videoLink",
//             "type": "string"
//           }
//         ],
//         "internalType": "struct Bord.Task[]",
//         "name": "",
//         "type": "tuple[]"
//       }
//     ],
//     "stateMutability": "view",
//     "type": "function"
//   },
//   {
//     "inputs": [
//       {
//         "internalType": "uint256",
//         "name": "_taskId",
//         "type": "uint256"
//       }
//     ],
//     "name": "getTask",
//     "outputs": [
//       {
//         "components": [
//           {
//             "internalType": "uint256",
//             "name": "taskId",
//             "type": "uint256"
//           },
//           {
//             "internalType": "address",
//             "name": "asker",
//             "type": "address"
//           },
//           {
//             "internalType": "address",
//             "name": "doer",
//             "type": "address"
//           },
//           {
//             "internalType": "string",
//             "name": "title",
//             "type": "string"
//           },
//           {
//             "internalType": "string",
//             "name": "content",
//             "type": "string"
//           },
//           {
//             "internalType": "uint256",
//             "name": "prize",
//             "type": "uint256"
//           },
//           {
//             "internalType": "uint256",
//             "name": "dateTimeCreated",
//             "type": "uint256"
//           },
//           {
//             "internalType": "uint256",
//             "name": "timeLimit",
//             "type": "uint256"
//           },
//           {
//             "internalType": "int256",
//             "name": "status",
//             "type": "int256"
//           },
//           {
//             "internalType": "string",
//             "name": "videoLink",
//             "type": "string"
//           }
//         ],
//         "internalType": "struct Bord.Task",
//         "name": "",
//         "type": "tuple"
//       }
//     ],
//     "stateMutability": "view",
//     "type": "function"
//   },
//   {
//     "inputs": [],
//     "name": "getTasksByAsker",
//     "outputs": [
//       {
//         "components": [
//           {
//             "internalType": "uint256",
//             "name": "taskId",
//             "type": "uint256"
//           },
//           {
//             "internalType": "address",
//             "name": "asker",
//             "type": "address"
//           },
//           {
//             "internalType": "address",
//             "name": "doer",
//             "type": "address"
//           },
//           {
//             "internalType": "string",
//             "name": "title",
//             "type": "string"
//           },
//           {
//             "internalType": "string",
//             "name": "content",
//             "type": "string"
//           },
//           {
//             "internalType": "uint256",
//             "name": "prize",
//             "type": "uint256"
//           },
//           {
//             "internalType": "uint256",
//             "name": "dateTimeCreated",
//             "type": "uint256"
//           },
//           {
//             "internalType": "uint256",
//             "name": "timeLimit",
//             "type": "uint256"
//           },
//           {
//             "internalType": "int256",
//             "name": "status",
//             "type": "int256"
//           },
//           {
//             "internalType": "string",
//             "name": "videoLink",
//             "type": "string"
//           }
//         ],
//         "internalType": "struct Bord.Task[]",
//         "name": "",
//         "type": "tuple[]"
//       }
//     ],
//     "stateMutability": "view",
//     "type": "function"
//   },
//   {
//     "inputs": [
//       {
//         "internalType": "uint256",
//         "name": "",
//         "type": "uint256"
//       }
//     ],
//     "name": "tasks",
//     "outputs": [
//       {
//         "internalType": "uint256",
//         "name": "taskId",
//         "type": "uint256"
//       },
//       {
//         "internalType": "address",
//         "name": "asker",
//         "type": "address"
//       },
//       {
//         "internalType": "address",
//         "name": "doer",
//         "type": "address"
//       },
//       {
//         "internalType": "string",
//         "name": "title",
//         "type": "string"
//       },
//       {
//         "internalType": "string",
//         "name": "content",
//         "type": "string"
//       },
//       {
//         "internalType": "uint256",
//         "name": "prize",
//         "type": "uint256"
//       },
//       {
//         "internalType": "uint256",
//         "name": "dateTimeCreated",
//         "type": "uint256"
//       },
//       {
//         "internalType": "uint256",
//         "name": "timeLimit",
//         "type": "uint256"
//       },
//       {
//         "internalType": "int256",
//         "name": "status",
//         "type": "int256"
//       },
//       {
//         "internalType": "string",
//         "name": "videoLink",
//         "type": "string"
//       }
//     ],
//     "stateMutability": "view",
//     "type": "function"
//   }
// ]