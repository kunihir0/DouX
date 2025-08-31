# VaultMediaItem Implementation Plan

This plan outlines the steps to create the `VaultMediaItem` feature, which will serve as the foundation for the private media vault.

## 1. Create `VaultMediaItem` Class

- **Create `VaultMediaItem.h` and `VaultMediaItem.m` files.**
- **Define the class properties in `VaultMediaItem.h`:**
    - `internalID`: A unique identifier for each item (e.g., an `NSString` created from `NSUUID`).
    - `filePath`: The path to the saved media file in the app's private data folder (`NSString`).
    - `creatorUsername`: The username of the original creator (`NSString`).
    - `contentType`: The type of media (photo or video), possibly using an enum (`typedef NS_ENUM(NSInteger, VaultMediaItemType) { VaultMediaItemTypePhoto, VaultMediaItemTypeVideo };`).
    - `savedDate`: The date the item was saved (`NSDate`).
    - `isFavorite`: A boolean to mark the item as a favorite (`BOOL`).
- **Implement `NSSecureCoding`:** To allow for saving and loading the `VaultMediaItem` objects to and from disk, the class should conform to the `NSSecureCoding` protocol. This involves implementing `initWithCoder:` and `encodeWithCoder:`.

## 2. Create `VaultManager` Class

- **Create `VaultManager.h` and `VaultManager.m` files.** This class will be a singleton responsible for managing all `VaultMediaItem` objects.
- **Implement the singleton pattern.**
- **Functionality:**
    - `loadVaultItems`: Loads all `VaultMediaItem` objects from a plist file in the app's documents directory.
    - `saveVaultItems`: Saves all `VaultMediaItem` objects to the plist file.
    - `addVaultItem:`: Adds a new `VaultMediaItem` to the vault and saves the changes.
    - `deleteVaultItem:`: Deletes a `VaultMediaItem` from the vault and its associated file from disk, then saves the changes.
    - `allItems`: Returns an array of all `VaultMediaItem` objects.
    - `favoriteItems`: Returns an array of all favorite `VaultMediaItem` objects.

## 3. Integrate with Existing Download Logic

- **Modify `BHIManager`'s `saveMedia:` method:**
    - Instead of just saving the file to the photo library, it should:
        1.  Move the downloaded file to a dedicated "Vault" directory within the app's documents folder.
        2.  Create a new `VaultMediaItem` object with the relevant information (file path, creator, etc.).
        3.  Add the new `VaultMediaItem` to the `VaultManager`.
- **Update `Tweak.x` download handlers:**
    - The download handlers in `AWEFeedViewTemplateCell` and `AWEAwemeDetailTableViewCell` will need to be updated to pass the necessary metadata (like the creator's username) to the `saveMedia:` method.

## 4. Create the Vault UI

- **Create a new `VaultViewController`:** This will be a `UICollectionViewController` to display the saved media items in a grid.
- **Design the `VaultCell`:** Create a custom `UICollectionViewCell` subclass to display a thumbnail of the media and an icon to indicate if it's a favorite.
- **Implement the `VaultViewController`:**
    - Load the `VaultMediaItem` objects from the `VaultManager`.
    - Implement the `UICollectionViewDataSource` and `UICollectionViewDelegate` protocols to display the items.
    - Add a segmented control to filter between "All" and "Favorites".
    - Add functionality to delete items (e.g., via a long press).
- **Integrate the `VaultViewController`:**
    - Add a "Vault" button to the `SecurityViewController` or another appropriate location in the app's UI to present the `VaultViewController`.

## 5. Refinement and Testing

- **Thumbnail Generation:** Implement a mechanism to generate and cache thumbnails for the video files to improve performance in the `VaultViewController`.
- **Error Handling:** Ensure robust error handling throughout the process, from downloading to saving and deleting.
- **Testing:** Thoroughly test the entire feature, including adding, viewing, favoriting, and deleting both photos and videos.
