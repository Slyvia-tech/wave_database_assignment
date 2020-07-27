SELECT COUNT (*) FROM users;

SELECT COUNT (*) FROM transfers WHERE send_amount_currency= 'CFA';

SELECT COUNT (DISTINCT u_id) FROM transfers WHERE send_amount_currency= 'CFA';

SELECT COUNT (atx_id) From agent_transactions
Where EXTRACT (YEAR FROM when_created)= 2018 
GROUP BY EXTRACT (MONTH FROM when_created);

SELECT SUM (CASE WHEN amount>0 THEN amount ELSE 0 END) AS withdrawal,
SUM(CASE WHEN amount<0 THEN amount ELSE 0 END)
AS deposit, 
CASE WHEN((SUM(CASE WHEN amount > 0
THEN amount ELSE 0 END)) > ((SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END)))*-1)
THEN 'withdrawal' ELSE 'depositor' END
AS agent_status, COUNT(*)
FROM agent_transactions WHERE when_created BETWEEN(now()-'1 WEEK'::INTERVAL)
AND now();

SELECT agents.city, COUNT (amount) FROM agent_transactions
INNER JOIN agents on agents.agent_id= agent_transactions.agent_id
WHERE agent_transactions.when_created > current_date -interval'7 days'
GROUP BY agents.city;


SELECT city, volume, country INTO atx_volume_city_summary_with_country
FROM(SELECT agents.city AS city, agents.country AS country, 
COUNT(agent_transactions.atx_id) AS volume FROM agents
INNER JOIN agent_transactions ON agents.agent_id= agent_transactions.agent_id 
where(agent_transactions.when_created>(NOW()-INTERVAL'1 week')) 
GROUP BY agents.country,agents.city) AS atx_volume_summary_with_country;

SELECT transfers.kind AS kind, wallets.ledger_location 
AS country, SUM(transfers.send_amount_scalar) AS volume From transfers
INNER JOIN wallets ON transfers.source_wallet_id= wallets.wallet_id
WHERE(transfers.when_created>(NOW()-INTERVAL'1 week'))
GROUP BY wallets.ledger_location, transfers.kind;

SELECT COUNT(transfers.source_wallet_id) AS unique_senders, COUNT(transfer_id)
AS transaction_count, transfers.kind AS transfers_kind, wallets.ledger_location
AS country, SUM(transfers.send_amount_scalar) AS volume FROM transfers 
INNER JOIN wallets ON transfers.source_wallet_id= wallets.wallet_id
WHERE(transfers.when_created>(NOW()-INTERVAL'1 WEEK')) 
GROUP BY wallets.ledger_location, transfers.kind;


SELECT source_wallet_id, send_amount_scalar FROM transfers 
WHERE send_amount_currency= 'CFA' AND (send_amount_scalar>10000000) 
AND (transfers.when_created>(NOW()-INTERVAL '1 month'));



