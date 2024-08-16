package com.example.stockapp.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class StockService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Transactional
    public void buyStock(Long membership, Long episodeId, Long stockId, Integer purchaseAmount) throws Exception {
        // 현재 보유 금액 조회
        Integer nowMoney = jdbcTemplate.queryForObject(
                "SELECT now_money FROM State WHERE membership = ? AND episode_id = ?",
                new Object[]{membership, episodeId},
                Integer.class
        );

        if (nowMoney == null || nowMoney < purchaseAmount) {
            throw new Exception("Insufficient funds");
        }

        // 투자 내역 추가
        jdbcTemplate.update(
                "INSERT INTO Invest (membership, episode_id, stock_id, invest_amount) VALUES (?, ?, ?, ?)",
                membership, episodeId, stockId, purchaseAmount
        );

        // 보유 금액 업데이트
        jdbcTemplate.update(
                "UPDATE State SET now_money = now_money - ? WHERE membership = ? AND episode_id = ?",
                purchaseAmount, membership, episodeId
        );

        // 투자 금액 저장
        jdbcTemplate.update(
                "INSERT INTO InvestAmount (invest_id, invest_total) VALUES (LAST_INSERT_ID(), ?)",
                purchaseAmount
        );
    }
}
