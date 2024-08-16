import java.util.*;
import java.sql.*;

class PriceChangeRange {
    private double min;
    private double max;
    private String eventGroup; // event_group을 String으로 변경

    public PriceChangeRange(double min, double max, String eventGroup) {
        this.min = min;
        this.max = max;
        this.eventGroup = eventGroup;
    }

    public double getMin() {
        return min;
    }

    public void setMin(double min) {
        this.min = min;
    }

    public double getMax() {
        return max;
    }

    public void setMax(double max) {
        this.max = max;
    }

    public String getEventGroup() {
        return eventGroup;
    }

    public void setEventGroup(String eventGroup) {
        this.eventGroup = eventGroup;
    }

    @Override
    public String toString() {
        return "PriceChangeRange{" +
                "min=" + min +
                ", max=" + max +
                ", eventGroup='" + eventGroup + '\'' +
                '}';
    }
}

public class price {
    private Map<String, Double> stocks; // 주식 가격을 저장하는 객체입니다.
    private Map<String, PriceChangeRange> priceChangeRanges; // 주식 가격 변동 범위를 저장하는 객체입니다.
    private Map<String, Integer> purchasedStocks; // 구매한 주식 정보를 저장하는 객체입니다.

    public price (Map<String, Double> stocks) { // 생성자입니다.
        this.stocks = stocks;
        this.priceChangeRanges = new HashMap<>();
        this.purchasedStocks = new HashMap<>();
    }

    // MySQL 데이터베이스에서 특정 주식의 가격 변동 범위를 불러오는 메소드입니다.
    public void loadPriceChangeRanges(String stockId) throws Exception {
        Connection connection = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/2024_swcontest", "your_username", "your_password");

        String query = "SELECT es.*, eg.event_group " +
                       "FROM EventStock es " +
                       "INNER JOIN EventGroup eg ON es.stock_id = eg.stock_id " +
                       "WHERE es.stock_id = ?";

        PreparedStatement statement = connection.prepareStatement(query);
        statement.setString(1, stockId);
        ResultSet resultSet = statement.executeQuery();

        while (resultSet.next()) {
            PriceChangeRange range = new PriceChangeRange(
                resultSet.getDouble("min"),
                resultSet.getDouble("max"),
                resultSet.getString("event_group")
            );
            priceChangeRanges.put(stockId, range);
        }

        resultSet.close();
        statement.close();
        connection.close();
    }

    // 주어진 범위 내에서 랜덤한 퍼센트를 반환하는 메소드입니다.
    public double getRandomPercentage(double min, double max) {
        Random random = new Random();
        return min + random.nextDouble() * (max - min);
    }

    // 주식을 구매하는 메소드입니다.
    public void buyStocks(String stockName, int shares) {
        if (!stocks.containsKey(stockName)) {
            System.out.println("Stock not found");
            return;
        }

        purchasedStocks.put(stockName, purchasedStocks.getOrDefault(stockName, 0) + shares);
        System.out.printf("%d shares of %s bought at initial price: %.2f%n", 
                           shares, stockName, stocks.get(stockName));
    }

    // 모든 주식의 가격 변동을 적용하는 메소드입니다.
    public void applyPriceChanges() {
        for (String stockName : stocks.keySet()) {
            PriceChangeRange range = priceChangeRanges.get(stockName);
 
            
            double changePercentage = getRandomPercentage(range.getMin(), range.getMax());
            double newPrice = stocks.get(stockName) * (1 + changePercentage);
            stocks.put(stockName, newPrice);

            System.out.printf("New price for %s (%s) is %.2f (changed by %.2f%%)%n", 
                               stockName, range.getEventGroup(), newPrice, changePercentage * 100);
        }
    }

    // 현재 주식 가격을 반환하는 메소드입니다.
    public Map<String, Double> getStockPrices() {
        return stocks;
    }

    // 데이터베이스에서 주식의 초기 가격을 불러오는 정적 메소드입니다.
    public static Map<String, Double> loadInitialStocks(String[] stockIds) throws Exception {
        Connection connection = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/stock_database", "your_username", "your_password");

        Map<String, Double> stocks = new HashMap<>();

        String query = "SELECT * FROM stocks WHERE stock_id = ?";
        PreparedStatement statement = connection.prepareStatement(query);

        for (String stockId : stockIds) {
            statement.setString(1, stockId);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                stocks.put(stockId, resultSet.getDouble("per_price"));
            }

            resultSet.close();
        }

        statement.close();
        connection.close();

        return stocks;
    }

   
    class StockMarket {
        public Map<String, Double> stockPrices;
        double min;
        double max;
        String eventGroup;
        public StockMarket(double min, double max, String eventGroup)
        {
        	this.min = min;
        	this.eventGroup =eventGroup;
        	this.max=max;
        	this.stockPrices = new HashMap<>();
        }
        public StockMarket(Map<String, Double> stockPrices) {
            this.stockPrices = stockPrices;
        }

        public Map<String, Double> getStockPrices() {
            return stockPrices;
        }

        public void buyStocks(String stockId, int quantity) {
            // 주식을 구매하는 로직
        }

        public void applyPriceChanges() {
            // 가격 변동을 적용하는 로직
        }
    }

    // 주식 그룹을 데이터베이스에서 불러오는 함수입니다.
    public class StockGroupLoader {

        // 데이터베이스에서 모든 주식 그룹을 로드하는 함수입니다.
        public static List<StockMarket> loadAllStockGroups() throws SQLException {
            String url = "jdbc:mysql://localhost:3306/your_database";
            String username = "root";
            String password = "password";

            String query = "SELECT s.stock_id, s.stock_name, g.group_name " +
                           "FROM Stock s " +
                           "INNER JOIN StockInGroup sg ON s.stock_id = sg.stock_id " +
                           "INNER JOIN StockGroup g ON sg.group_id = g.group_id";

            Map<String, StockMarket> groups = new HashMap<>();

            try (Connection connection = DriverManager.getConnection(url, username, password);
                 PreparedStatement statement = connection.prepareStatement(query);
                 ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {
                    String stockId = resultSet.getString("stock_id");
                    String stockName = resultSet.getString("stock_name");
                    String groupName = resultSet.getString("group_name");

                    // 그룹 이름을 키로 사용하여 StockMarket 객체를 맵에 저장
                    groups.computeIfAbsent(groupName, k -> new StockMarket(new HashMap<>()))
                          .getStockPrices().put(stockId, 100.0); 
                }
            }

            return new ArrayList<>(groups.values());
        }

        // 랜덤으로 주식 시장을 실행하는 함수입니다.
        public static void runRandomStockMarket() throws Exception {
            // 주식 그룹 로드
            List<StockMarket> groups = loadAllStockGroups();
            if (groups.isEmpty()) {
                throw new Exception("No stock groups available.");
            }

            // 랜덤으로 그룹 선택
            Random random = new Random();
            StockMarket randomGroup = groups.get(random.nextInt(groups.size()));

            // 선택된 그룹의 주식 ID 선택
            Map<String, Double> stockPrices = randomGroup.getStockPrices();
            if (stockPrices.isEmpty()) {
                throw new Exception("No stocks available in the selected group.");
            }

            String randomStockId = stockPrices.keySet().iterator().next(); // 첫 번째 주식 ID를 가져옵니다.

            // 가격 변동 범위 로드
            randomGroup.loadPriceChangeRanges(randomStockId);

            // 주식 구매
            randomGroup.buyStocks(randomStockId, 10); // 예시로 첫 번째 주식을 10주 구매합니다.

            // 가격 변동 적용 전 주식 가격 출력
            System.out.println("Stock prices before applying changes:");
            System.out.println(randomGroup.getStockPrices());

            // 가격 변동 적용
            randomGroup.applyPriceChanges();

            // 가격 변동 적용 후 주식 가격 출력
            System.out.println("Stock prices after applying changes:");
            System.out.println(randomGroup.getStockPrices());
        }

        public static void main(String[] args) {
            try {
                runRandomStockMarket();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
