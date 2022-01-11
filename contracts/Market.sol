// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./IERC721.sol";

contract Market {

	enum ListingStatus {Active, Sold , Cancelled }

	struct Listing {
		ListingStatus status;
		address seller;
		address token;
		uint tokenId;
		uint price;
	}
	// events for listing , selling and cancelling
	event Listed (uint listingId ,address seller, address token, uint tokenId , uint price);
	event Sale (uint listingId , address seller , address buyer , uint tokenid, uint price);
	event Cancelled(uint listingId , address seller);


	mapping(uint => Listing) private _listings;
	uint private _listingId = 0;



	function listTOken (address token, uint tokenId , uint price) public {
		IERC721(token).transferFrom(msg.sender, address(this), tokenId);

		Listing memory listing = Listing (ListingStatus.Active, msg.sender , token, tokenId , price);
		_listingId ++;

		_listings[_listingId] = listing;
		emit Listed (_listingId , msg.sender , token , tokenId , price);

	}


	// function to get a listing 

	function getListing (uint listingId) public view returns(Listing memory) {
		return _listings[listingId];

	}

	function buyToken (uint listingId) external payable {
		Listing storage listing = _listings[listingId];
		require(listing.status == ListingStatus.Active , "Token has not been listed!");
		require(msg.sender != listing.seller , "You cannot buy your own NFTs");
		require(msg.value >= listing.price , "Insufficient Funds");

		// checks and ensure payment is made before assets are transfered and status is set to sold
		payable(listing.seller).transfer(listing.price);
		IERC721(listing.token).transferFrom(address(this), msg.sender, listing.tokenId);
		listing.status = ListingStatus.Sold;

		emit Sale (listingId , listing.seller , msg.sender , listing.tokenId , listing.price);
		
	}

	function cancel (uint listingId) public {
		Listing storage listing = _listings[listingId];
		require(listing.status == ListingStatus.Active , "Art is not listed");
		require(msg.sender == listing.seller, "You are not authorized to unlist this NFT");

		listing.status = ListingStatus.Cancelled;
		IERC721(listing.token).transferFrom(address(this), msg.sender, listing.tokenId);

		emit Cancelled(listingId, listing.seller);

	}
}