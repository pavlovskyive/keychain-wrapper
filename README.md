# KeychainWrapper

A simple wrapper for the iOS / MacOS Keychain to allow you to use it in a similar fashion to User Defaults, but securely.

Written in Swift

**Safely handles errors via do-catch statements** _(No unnecessary unwrapping and checking Bool values to see if data is saved, as you'll have to do using most popular libraries)_.

## Usage

**Preparation:**

Instantiate an KeychainWrapper instance:

(Yep, no singletons, we care about app architecture.)

``` swift
let secureStorage = KeychainWrapper()
```
---

Save data to Keychain:

``` swift
do {
    let value = try secureStorage.set(token, forKey: "token")
} catch {
    print(error.localizedDescription)
}

// OR, simply
// try? secureStorage.set(token, forKey: "token")
```

---

Retrieve data from Keychain:

``` swift
do {
    let value = try secureStorage.get(forKey: "token")
} catch {
    print(error.localizedDescription)
}
```

---

Delete entry from Keychain:

``` swift
try? secureStorage.delete(forKey: "token")

// NOTE: Also you can set entry to empty string to remove it from Keychain
// try? secureStorage.set("", forKey: "token")
```

---

To update value for key, just set it as new:

``` swift
try? secureStorage.set(token, forKey: "token")
try? secureStorage.set(newToken, forKey: "token")
```
