package com.example.stockapp.controller;

import com.example.stockapp.service.StockService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class StockController {

    @Autowired
    private StockService stockService;

    @PostMapping("/buy-stock")
    public ResponseEntity<String> buyStock(
            @RequestParam Long membership,
            @RequestParam Long episodeId,
            @RequestParam Long stockId,
            @RequestParam Integer purchaseAmount) {

        try {
            stockService.buyStock(membership, episodeId, stockId, purchaseAmount);
            return ResponseEntity.ok("Purchase successful");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Purchase failed: " + e.getMessage());
        }
    }
}
