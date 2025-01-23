// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CertificateIssuer is ERC721URIStorage, Ownable {
    uint256 public certificateCounter;
    mapping(uint256 => string) public certificateDetails; // Mapping to store certificate details like course, grade, etc.

    event CertificateIssued(
        uint256 indexed certificateId,
        address indexed recipient,
        string certificateURI
    );

    constructor() ERC721("CertificateToken", "CTK") {}

    // Function to issue a certificate to a recipient
    function issueCertificate(
        address recipient,
        string memory certificateURI,
        string memory details
    ) external onlyOwner {
        uint256 certificateId = certificateCounter++;
        _mint(recipient, certificateId); // Mint a new unique token (certificate) to the recipient
        _setTokenURI(certificateId, certificateURI); // Store the URI pointing to the certificate's details (e.g., JSON metadata)

        certificateDetails[certificateId] = details; // Store additional details about the certificate (e.g., course name, grade)

        emit CertificateIssued(certificateId, recipient, certificateURI);
    }

    // Function to get certificate details
    function getCertificateDetails(
        uint256 certificateId
    ) external view returns (string memory) {
        return certificateDetails[certificateId];
    }

    // Function to verify certificate ownership
    function verifyCertificate(
        uint256 certificateId
    ) external view returns (address) {
        return ownerOf(certificateId); // Returns the address that owns the certificate
    }

    // Override _baseURI for metadata linking
    function _baseURI() internal view virtual override returns (string memory) {
        return "https://example.com/metadata/"; // Replace with your own base URI or metadata service
    }

    // Optional: Function to revoke a certificate (only owner can do this)
    function revokeCertificate(uint256 certificateId) external onlyOwner {
        require(_exists(certificateId), "Certificate does not exist");
        _burn(certificateId); // Burn the certificate NFT if revoked
    }
}
