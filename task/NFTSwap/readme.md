使用 Solidity 实现一个 NFT Swap

利用智能合约搭建一个零手续费的去中心化 NFT 交易所，主要逻辑：

- 卖家：出售 NFT 的一方，可以挂单 list、撤单 revoke、修改价格 update。

- 买家：购买 NFT 的一方，可以购买 purchase。

- 订单：卖家发布的 NFT 链上订单，一个系列的同一 tokenId 最多存在一个订单，其中包含挂单价格 price 和持有人 owner 信息。当一个订单交易完成或被撤单后，其中信息清零。
