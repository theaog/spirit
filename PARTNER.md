# Spirit Partnership Program

```bash
$ ./spirit partner
```
Become a Spirit partner and benefit of 10% discount on licenses and up to 30% referral fee wired Monthly to your Wallet.

## Benefits
- referred users benefit of a 10% discount when requesting a license
- partners benefit of up to 30% refer fee wired monthly to their XMR wallet

## Commission levels
- <=3 referrals/month (10% commission)
- >3 and <=10 referrals/month (20% commission)
- >10 referrals/month (30% commission)

NOTE: You must generate at least 3 refers per month in order to receive commission.

## Example
```sql
+----+-------------------------------------+------------+------+------------+-------------+----------+-----------------------+
| id |             created_at              | license_id | plan |   amount   | commission  | referred | partner_referral_code |
+----+-------------------------------------+------------+------+------------+-------------+----------+-----------------------+
| 51 | 2024-05-06 16:23:49.360913449+00:00 | 106        | 0    | 0.18108999 | 0.018108999 | 1        | spirit_aea01          |
| 51 | 2024-05-06 16:26:49.360913449+00:00 | 107        | 1    | 3.18108999 | 0.318108999 | 1        | spirit_aea02          |
+----+-------------------------------------+------------+------+------------+-------------+----------+-----------------------+
```
Partner refer fees are calculated automatically by the system on order and based on the number of orders w/ the same Partner Code the fee will be doubled or tripled before wiring the total to the Partner XMR wallet
