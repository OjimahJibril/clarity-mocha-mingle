import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Can mint a new recipe NFT",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet1 = accounts.get("wallet_1")!;
    const block = chain.mineBlock([
      Tx.contractCall(
        "recipe-nft",
        "mint-recipe",
        [
          types.utf8("Cappuccino"),
          types.utf8("Coffee, milk"),
          types.utf8("1. Brew coffee 2. Steam milk")
        ],
        wallet1.address
      ),
    ]);
    block.receipts[0].result.expectOk().expectUint(1);
  },
});

Clarinet.test({
  name: "Cannot transfer recipe NFT if not owner",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet1 = accounts.get("wallet_1")!;
    const wallet2 = accounts.get("wallet_2")!;
    
    // First mint NFT
    let block = chain.mineBlock([
      Tx.contractCall(
        "recipe-nft",
        "mint-recipe",
        [
          types.utf8("Cappuccino"),
          types.utf8("Coffee, milk"),
          types.utf8("1. Brew coffee 2. Steam milk")
        ],
        wallet1.address
      ),
    ]);
    
    // Try unauthorized transfer
    block = chain.mineBlock([
      Tx.contractCall(
        "recipe-nft",
        "transfer-recipe",
        [types.uint(1), types.principal(wallet2.address)],
        wallet2.address
      ),
    ]);
    
    block.receipts[0].result.expectErr().expectUint(401);
  },
});
