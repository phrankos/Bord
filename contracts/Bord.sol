// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SocialMedia {
    struct Post {
        address author;
        string content;
        uint256 timestamp;
    }

    Post[] public posts;

    function createPost(string memory _content) public {
        Post memory newPost;
        newPost.author = msg.sender;
        newPost.content = _content;
        newPost.timestamp = block.timestamp;

        posts.push(newPost);
    }

    function getPosts() public view returns (Post[] memory) {
        return posts;
    }
}