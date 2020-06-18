# Usage

1. Create a database where you'll store the data.
2. Run the below script to generate the Korean StackExchange dump. Optionally, you can choose a different dump [here](https://ia800107.us.archive.org/27/items/stackexchange/).
3. Deploy the database using Sqitch.

## Quick start
```bash
npm install
curl https://ia800107.us.archive.org/27/items/stackexchange/korean.stackexchange.com.7z --output dump.7z
npm run generate dump.7z
```