// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "./metaNFT.sol";
import "./buyPrice.sol";
import "./MXLToken.sol";

contract METAXLAND is Ownable {
    metaX meta;
    landPriceing land;
    metaXtoken token;
    event BUYLAND(
        uint256 landID,
        address buyer,
        uint256[] tiles,
        string URIDetail,
        uint256 landAmount
    );
    event SELLLAND(uint256 landID, address owner, address buyer);

 

    constructor(
        address nftaddr,
        address priceaddr,
        address TokenAddress
    ) {
        meta = metaX(nftaddr);
        land = landPriceing(priceaddr);
        token = metaXtoken(TokenAddress);
    }

    function buyLand(
        uint256 id_,
        uint256[] memory tile_,
        string memory uri,
        string memory _land,
        address addr,
        bool exist
    ) external {
        require(tile_.length > 0, "gt 0");
        uint256 amount = land.getAmount(_land) * tile_.length;
        meta.setTile(id_, tile_);
        meta.safeMint(msg.sender, id_, uri);
        if (exist == true) {
            uint256 amount1 = (amount * 10) / 100;
            uint256 amount2 = amount - amount1;
            token.tokenTransfer(msg.sender, addr, amount2);
            token.tokenTransfer(msg.sender, owner(), amount1);
        } else {
            token.tokenTransfer(msg.sender, owner(), amount);
        }
        emit BUYLAND(id_, msg.sender, tile_, uri, amount);
    }

    function sellLand(
        uint256 id,
        address to,
        address addr_,
        uint256 amount_
    ) external {
        meta.transferFrom(msg.sender, to, id);
        uint256 charge = (amount_ * 10) / 100;
        uint256 broker = (charge * 70) / 100;
        uint256 buyer = amount_ - charge;
        uint256 platform = charge - broker;
        token.tokenTransfer(msg.sender, addr_, broker);
        token.tokenTransfer(msg.sender, address(this), platform);
        token.tokenTransfer(msg.sender, to, buyer);
        emit SELLLAND(id, meta.ownerOf(id), to);
    }
}
