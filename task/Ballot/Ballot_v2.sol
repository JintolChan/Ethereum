// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ballot {
    struct Voter {
        uint weight; // 权重，通过委托累积
        bool voted;  // 如果为 true，表示该人已投票
        address delegate; // 被委托人地址
        uint vote;   // 投票提案的索引
    }

    struct Proposal {
        string name;   // 提案的名称 (最多 32 字节)
        uint voteCount; // 累积的投票数
    }

    address public chairperson; // 主持人地址

    mapping(address => Voter) public voters; // 投票人地址到 Voter 结构的映射

    Proposal[] public proposals; // 提案数组

    uint public startTime; // 投票开始时间
    uint public endTime;   // 投票结束时间

    // 构造函数，初始化提案和投票时间
    constructor(string[] memory proposalNames, uint _startTime, uint _endTime) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        require(_endTime > _startTime, unicode"结束时间必须大于开始时间");
        startTime = _startTime;
        endTime = _endTime;

        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    // 赋予投票权，只有主持人可以调用
    function giveRightToVote(address voter) public {
        require(
            msg.sender == chairperson,
            unicode"只有主持人可以赋予投票权."
        );
        require(!voters[voter].voted, unicode"该投票者已经投过票.");
        require(voters[voter].weight == 0, unicode"该投票者已经拥有投票权.");
        voters[voter].weight = 1;
    }

    // 设置投票者的权重，只有主持人可以调用
    function setVoterWeight(address voter, uint weight) public {
        require(msg.sender == chairperson, unicode"只有主持人可以设置投票权重.");
        require(block.timestamp >= startTime, unicode"投票尚未开始.");
        require(block.timestamp <= endTime, unicode"投票已经结束.");
        require(!voters[voter].voted, unicode"该投票者已经投过票.");
        voters[voter].weight = weight;
    }

    // 投票函数
    function vote(uint proposal) public {
        require(block.timestamp >= startTime, unicode"投票尚未开始.");
        require(block.timestamp <= endTime, unicode"投票已经结束.");

        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, unicode"没有投票权");
        require(!sender.voted, unicode"已经投过票.");
        sender.voted = true;
        sender.vote = proposal;

        // 如果 `proposal` 超出数组范围，
        // 将自动抛出异常并回滚所有更改。
        proposals[proposal].voteCount += sender.weight;
    }

    // 返回获胜提案的索引
    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    // 返回获胜提案的名称
    function winnerName() public view returns (string memory winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }
}