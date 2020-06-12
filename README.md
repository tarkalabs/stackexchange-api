# Usage

1. Create a database where you'll store the data.
2. Run the below script to compile and generate the Korean StackExchange dump. Optionally, you can choose a different dump [here](https://ia800107.us.archive.org/27/items/stackexchange/).
3. Deploy the database using Sqitch.

```bash
npm install
npm run build
curl https://ia800107.us.archive.org/27/items/stackexchange/korean.stackexchange.com.7z --output dump.7z
npm run generate dump.7z
```