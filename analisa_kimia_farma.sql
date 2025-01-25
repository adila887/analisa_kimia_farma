CREATE OR REPLACE TABLE kimia_farma.tabel_analisa AS
SELECT 
    t.transaction_id,                        -- ID transaksi
    t.date,                                  -- Tanggal transaksi
    b.branch_id,                             -- ID cabang
    b.branch_name,                           -- Nama cabang
    b.kota,                                  -- Kota cabang
    b.provinsi,                              -- Provinsi cabang
    b.rating AS rating_cabang,               -- Rating cabang
    t.customer_name,                         -- Nama customer
    p.product_id,                            -- ID produk
    p.product_name,                          -- Nama produk
    t.price AS actual_price,                 -- Harga produk
    t.discount_percentage,                   -- Persentase diskon
    CASE
        WHEN t.price <= 50000 THEN 0.1
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.2
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        ELSE 0.3
    END AS persentase_gross_laba,            -- Persentase laba
    (t.price - (t.price * t.discount_percentage / 100)) AS nett_sales,   -- Harga setelah diskon
    (t.price - (t.price * t.discount_percentage / 100)) * CASE
        WHEN t.price <= 50000 THEN 0.1
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.2
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        ELSE 0.3
    END AS nett_profit,                      -- Keuntungan bersih
    t.rating AS rating_transaksi,            -- Rating transaksi
    i.opname_stock AS stok_tersedia          -- Stok dari inventory
FROM 
    kimia_farma.kf_final_transaction AS t
JOIN 
    kimia_farma.kf_kantor_cabang AS b
ON 
    t.branch_id = b.branch_id
JOIN 
    kimia_farma.kf_product AS p
ON 
    t.product_id = p.product_id
JOIN
    kimia_farma.kf_inventory AS i 
ON
    t.product_id = i.product_id AND
    t.branch_id = i.branch_id;