/* MySQL 사용 시 무조건 아래 쿼리문 실행시킨 후 나머지 해야 함! */
USE 2024_swcontest;


/* 테이블 생성 */
CREATE TABLE User (
    membership INT UNSIGNED NOT NULL PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    nickname VARCHAR(10) NOT NULL,
    user_id VARCHAR(15) NOT NULL,
    password VARBINARY(15) NOT NULL,
    affiliation VARCHAR(10) NOT NULL
);

CREATE TABLE Episode (
    episode_id INT UNSIGNED NOT NULL PRIMARY KEY,
    episode_title VARCHAR(10) NOT NULL
);

CREATE TABLE ScoreWeek (
    score_id INT UNSIGNED NOT NULL PRIMARY KEY,
    episode_id INT UNSIGNED NOT NULL,
    week INT UNSIGNED NOT NULL,
    score INT UNSIGNED NOT NULL,
    membership INT UNSIGNED NOT NULL,
    FOREIGN KEY (episode_id) REFERENCES Episode(episode_id),
    FOREIGN KEY (membership) REFERENCES User(membership)
);

CREATE TABLE Total (
    total_id INT UNSIGNED NOT NULL PRIMARY KEY,
    episode_id INT UNSIGNED NOT NULL,
    membership INT UNSIGNED NOT NULL,
    score_total INT NOT NULL,
    FOREIGN KEY (episode_id) REFERENCES Episode(episode_id),
    FOREIGN KEY (membership) REFERENCES User(membership)
);

CREATE TABLE Stock (
    stock_id INT UNSIGNED NOT NULL PRIMARY KEY,
    company VARCHAR(15) NOT NULL,
    per_price INT UNSIGNED NOT NULL,
    amount_change INT NOT NULL,
    rate_change INT NOT NULL,
    company_explanation VARCHAR(50) NOT NULL
);

CREATE TABLE Event (
    event_id INT UNSIGNED NOT NULL PRIMARY KEY,
    episode_id INT UNSIGNED NOT NULL,
    event_title VARCHAR(10) NOT NULL,
    event_group INT NOT NULL,
    FOREIGN KEY (episode_id) REFERENCES Episode(episode_id)
);

CREATE TABLE GroupArticle (
    event_group INT NOT NULL,
    article_order INT UNSIGNED NOT NULL,
    article_title VARCHAR(50) NOT NULL,
    article_detail VARCHAR(300) NOT NULL,
    PRIMARY KEY (event_group, article_order)
);

CREATE TABLE EventStock (
    stock_id INT UNSIGNED NOT NULL PRIMARY KEY,
    min INT NOT NULL,
    max INT NOT NULL,
    result_explanation VARCHAR(200) NOT NULL,
    FOREIGN KEY (stock_id) REFERENCES Stock(stock_id)
);

CREATE TABLE Invest (
    invest_id INT UNSIGNED NOT NULL PRIMARY KEY,
    membership INT UNSIGNED NOT NULL,
    episode_id INT UNSIGNED NOT NULL,
    stock_id INT UNSIGNED NOT NULL,
    invest_amount INT UNSIGNED NOT NULL,
    FOREIGN KEY (membership) REFERENCES User(membership),
    FOREIGN KEY (episode_id) REFERENCES Episode(episode_id),
    FOREIGN KEY (stock_id) REFERENCES Stock(stock_id)
);

CREATE TABLE InvestAmount (
    invest_id INT UNSIGNED NOT NULL PRIMARY KEY,
    invest_total INT NOT NULL,
    FOREIGN KEY (invest_id) REFERENCES Invest(invest_id)
);

CREATE TABLE InvestResult (
    invest_id INT UNSIGNED NOT NULL PRIMARY KEY,
    insert_result INT NOT NULL,
    FOREIGN KEY (invest_id) REFERENCES Invest(invest_id)
);

CREATE TABLE State (
    state_id INT UNSIGNED NOT NULL PRIMARY KEY,
    week INT NOT NULL,
    membership INT UNSIGNED NOT NULL,
    episode_id INT UNSIGNED NOT NULL,
    invest_id INT UNSIGNED NOT NULL,
    now_money INT UNSIGNED NOT NULL,
    FOREIGN KEY (membership) REFERENCES User(membership),
    FOREIGN KEY (episode_id) REFERENCES Episode(episode_id),
    FOREIGN KEY (invest_id) REFERENCES Invest(invest_id)
);


/* 테이블 수정 코드 */
ALTER TABLE Event 
ADD COLUMN article_order INT UNSIGNED,
ADD UNIQUE (article_order); -- UNIQUE 제약조건을 걸어 1:1 관계를 보장

ALTER TABLE GroupArticle 
ADD COLUMN event_id INT UNSIGNED,
ADD UNIQUE (event_id), -- UNIQUE 제약조건을 걸어 1:1 관계를 보장
ADD FOREIGN KEY (event_id) REFERENCES Event(event_id) ON DELETE CASCADE;


/* grouparticle 저장 */
INSERT INTO grouparticle VALUE (1, 1, '팬데믹 확산, 글로벌 입국 제한 조치 강화', '1달 전 시작된 팬데믹이 전 세계적으로 심각해지고 있습니다. 각국은 바이러스 확산을 막기 위해 입국 제한 조치를 강화하고 있습니다. 특히, 주요 국가들이 자국민 보호를 위해 국경을 봉쇄하고 있습니다. 이에 따라 글로벌 경제 활동이 크게 위축되고 있습니다. 동시에, 여러 제약 회사가 치료제 개발에 박차를 가하고 있습니다.'),
(1, 2, '예상보다 부진한 경제지표, 시장 우려 확산', '최근 발표된 경제지표가 시장의 예상보다 나쁘게 나왔습니다. 주요 산업의 생산성과 소비 지표가 모두 하락세를 보였습니다. 이는 경기 침체 우려를 더욱 가중시키고 있습니다. 투자자들은 향후 경제 회복 속도에 대한 불확실성에 주목하고 있습니다. 이러한 부정적인 지표는 주식 시장에 하방 압력을 가하고 있습니다.'),
(2, 3, '전기차 산업, 지속 가능한 미래의 주역', '전기차 산업이 지속 가능한 미래를 이끌어가는 주요 산업으로 떠오르고 있습니다. 혁신적인 기술 발전으로 전기차의 효율성과 성능이 크게 향상되었습니다. 전통적인 내연기관 자동차를 대체할 수 있는 강력한 대안으로 주목받고 있습니다. 특히, 친환경 정책 강화로 인해 전기차 수요가 급증하고 있습니다. 이에 따라 전기차 관련 기업들의 성장 전망이 밝아지고 있습니다.'),
(2, 4, '중앙은행, 금리 인상 발표로 시장 긴장', '중앙은행이 금리 인상 결정을 발표하면서 금융 시장이 긴장하고 있습니다. 금리 인상은 물가 상승을 억제하기 위한 조치로 해석되고 있습니다. 그러나 이는 기업들의 자금 조달 비용을 증가시켜 경제 성장에 부정적인 영향을 미칠 수 있습니다. 투자자들은 금리 인상으로 인한 시장 변동성에 주목하고 있습니다. 일부 전문가들은 추가 금리 인상 가능성을 경고하고 있습니다.'),
(2, 5, '아이돌 그룹 \'스타라이트\', 해외 진출 성공', 'K-POP 아이돌 그룹 \'스타라이트\'가 해외 시장에서 큰 성공을 거두고 있습니다. 이들은 최근 미국 투어를 통해 현지 팬들의 열렬한 지지를 받았습니다. \'스타라이트\'의 앨범은 미국 빌보드 차트 상위권에 진입하며 인기를 입증했습니다. 이로 인해 K-POP의 글로벌 영향력이 더욱 강화되고 있습니다. 한국의 문화 콘텐츠 수출도 함께 증가할 것으로 예상됩니다.'),
(3, 6, '무역전쟁 격화, \'A전자\' 불매 운동 확산', '무역전쟁이 심화되면서 글로벌 전자기기 기업 \'A전자\'가 타격을 입고 있습니다. 특정 국가에서 \'A전자\' 제품에 대한 불매 운동이 확산되고 있습니다. 이는 양국 간의 갈등이 첨예화된 결과로, \'A전자\'의 수익성에 악영향을 미치고 있습니다. 글로벌 시장에서의 점유율 하락도 우려됩니다. 무역전쟁의 여파로 기업들이 어려움을 겪고 있습니다.'),
(3, 7, '\'테크온\', 예상보다 좋은 실적 발표', 'IT 기업 \'테크온\'이 예상보다 뛰어난 분기 실적을 발표했습니다. 매출과 순이익 모두 시장의 기대치를 상회하며 큰 폭으로 증가했습니다. 이는 신제품 출시와 글로벌 시장 확대 전략이 주효한 결과로 분석됩니다. 실적 발표 이후 \'테크온\'의 주가는 상승세를 보였습니다. 투자자들은 향후 성장 가능성에 주목하고 있습니다.'),
(3, 8, '\'퓨처텍\' 예상치 못한 CEO 교체, 경영 우려', '첨단 기술 기업 \'퓨처텍\'이 예기치 않은 경영진 변화를 발표했습니다. 기존 CEO의 갑작스러운 사임으로 인해 새로운 CEO가 취임하게 되었습니다. 이로 인해 기업의 경영 전략과 향후 성장 계획에 대한 불확실성이 커지고 있습니다. 투자자들은 이번 변화가 회사에 미칠 영향을 주의 깊게 지켜보고 있습니다.'),
(4, 9, '원화 약세, 달러 강세로 수출기업 부담 증가', '최근 원화가 약세를 보이고 있는 가운데, 달러는 강세를 지속하고 있습니다. 이로 인해 한국의 수출 기업들이 큰 부담을 겪고 있습니다. 달러 강세로 인해 원자재 수입 비용이 증가하면서 기업들의 수익성이 악화되고 있습니다. 특히, 전자 및 자동차 산업이 큰 타격을 입고 있습니다. 경제 전문가들은 환율 변동성에 대한 대응이 필요하다고 강조하고 있습니다.'),
(4, 10, '원유가격 급등, 에너지 기업들 이익 증가', '최근 원유가격이 급등하면서 에너지 기업들이 큰 이익을 보고 있습니다. 글로벌 수요 증가와 공급 제한이 원유가격 상승의 주요 요인으로 작용하고 있습니다. 특히, \'오일파워\'와 같은 대형 에너지 기업들이 수혜를 입고 있습니다. 주가는 이러한 흐름에 따라 상승세를 보이고 있습니다. 다만, 원유가격 급등이 소비자 물가에 미칠 영향에 대한 우려도 제기되고 있습니다.'),
(4, 11, '인플레이션율 발표: 인플레이션 상승 전망, 시장 우려 확대', '최근 발표된 인플레이션율이 예상보다 높은 상승세를 보일 것이라는 전망이 나왔습니다. 이는 소비자 물가 상승과 구매력 저하를 초래할 수 있는 요인으로 작용하고 있습니다. 중앙은행의 금리 인상 가능성도 함께 제기되고 있습니다. 이에 따라 주식 시장은 변동성을 보이고 있습니다. 전문가들은 인플레이션 관리가 경제 안정에 중요한 역할을 할 것이라고 분석합니다.');


/* episode 저장 */
INSERT INTO episode VALUES(1, '주식'), (2, '부동산'), (3, '외화'), (4, '채권');


/* event 저장 */
INSERT INTO event VALUES (1, 1, '전염병', 1, 1),
(2, 1, '경제지표', 1, 2),
(3, 1, '기술 발전', 2, 3),
(4, 1, '금리인상발표', 2, 4),
(5, 1, 'KPOP 해외진출', 2, 5),
(6, 1, '무역전쟁', 3, 6),
(7, 1, '기업실적발표', 3, 7),
(8, 1, '경영진 변화', 3, 8),
(9, 1, '환율변동', 4, 9),
(10, 1, '원유가격변동', 4, 10),
(11, 1, '인플레이션율 발표', 4, 11);


/* 테이블 수정 코드2, % 기호를 넣기 위해 INT -> VARCHAR(10)으로 변경하고 company 글자수가 길어져서 글자수 제한을 늘림 */
ALTER TABLE Stock
MODIFY rate_change VARCHAR(10) NOT NULL;

ALTER TABLE Stock
MODIFY company VARCHAR(30) NOT NULL;


/* stock 저장 -> 추후에 파일 넘겨받고 */
INSERT INTO stock VALUES (1, 'A 제약', 130000, 20000, '+15.38%', '최근 유행하는 전염병의 치료제를 만드는 기업'),
(2, 'B 비디오 회의 어플', 70000, 40000, '+57.14%', '비대면 회의를 위한 플랫폼을 전세계에 제공중인 기업'),
(3, 'C 항공', 20000, -5000, '-25.00%', '미국 항공사 기업'),
(4, 'GE(General Electric)', 30000, -1000, '-3.33%', '세계 최대의 글로벌 인프라 대기업'),
(5, 'E 전기차', 230000, 100000, '+43.48%', '최근 빠르게 성장 중인 전기차 개발 기업'),
(6, 'F 내연기관 자동차', 110000, -30000, '-27.27%', '기존 내연기관 자동차를 제작 및 판매하는 기업'),
(7, 'S&P', 40000, -2000, '-5.00%', '세계 3대 신용평가 기업'),
(8, 'H 엔터', 130000, 3000, '+2.31%', '아이돌 및 배우를 육성하는 한국의 엔터 기업'),
(9, 'I 방위산업', 35000, 5000, '+14.29%', '실제 군수 무기 및 사이버 공격시 사용되는 무기들을 제작  및 판매하는 기업'),
(10, 'J 전자', 150000, 10000, '+6.67%', '미국의 대표 전자기기 판매 기업'),
(11, 'K 기업', 90000, 5000, '+5.56%', '최근 기업실적이 좋게 발표된 기업'),
(12, 'L 기업', 70000, 10000, '+14.29%', '최근 경영진 변화가 발표된 기업'),
(13, 'M 기업', 300000, 5000, '+1.67%', '한국의 식재료를 외국으로 수출하는 한국 기업'),
(14, 'N 기업', 150000, 3000, '+2.00%', '미국의 식재료를 한국으로 수출하는 미국 기업'),
(15, 'O 에너지', 70000, 10000, '+14.29%', '원유를 판매하는 에너지 기업'),
(16, 'P 기업', 60000, 5000, '+8.33%', '서민들이 주 판매고객인 식재료 판매 기업');


/* eventstock 저장 -> 추후에 로직 확인하고 + 파일 넘겨받고 */
INSERT INTO eventstock VALUES (1, 25, 35, '전염병 발생 시 치료제와 백신에 대한 수요가 급증하여 제약회사들이 해당 제품을 개발하고 판매할 가능성이 높아집니다. 이에 따라 제약회사들의 매출과 이익이 증가할 것으로 예상되어 주가가 상승합니다.'),
(2, 120, 160, '전염병으로 인해 재택근무와 원격 학습이 보편화되면서 비디오 커뮤니케이션 도구의 수요가 급증합니다. 이에 따라 해당 기업들의 사용자 수와 매출이 증가하면서 주가가 상승합니다.'),
(3, -40, -50, '전염병 확산으로 인해 여행 제한 및 항공편 취소가 빈번해져 항공사들의 수익이 급감합니다. 이에 따라 항공사의 재정 상태가 악화될 것이라는 우려로 주가가 하락합니다.'),
(4, -3, -5, '경제지표가 예상보다 나쁘게 발표되면 경제 성장 둔화 우려가 커집니다. GE와 같은 대기업의 미래 수익성에 대한 우려로 인해 투자자들이 주식을 매도하여 주가가 하락합니다.'),
(5, 200, 230, '전기차 관련 기술 발전으로 인해 전기차의 효율성과 성능이 향상됩니다. 이에 따라 전기차 수요 증가와 시장 점유율 확대가 기대되면서 주가가 상승합니다.'),
(6, -25, -40, '전기차 기술 발전과 시장 확대로 인해 내연기관 자동차의 수요가 감소합니다. 이로 인해 내연기관 자동차 제작 기업의 주가가 하락합니다.'),
(7, -3, -8, '금리 인상으로 인해 기업의 대출 비용이 증가하고 소비자 지출이 감소할 수 있습니다. 이에 따라 기업들의 수익성이 악화될 것으로 예상되어 S&P 500 지수가 하락합니다.'),
(8, 5, 7, 'KPOP의 해외 진출로 글로벌 시장에서의 매출 증가와 팬층 확대가 기대됩니다. 이에 따라 관련 엔터기업들의 수익성이 향상될 것으로 예상되어 주가가 상승합니다.'),
(9, 15, 20, '무역전쟁으로 인해 국가 간 긴장이 고조되면서 방위산업에 대한 수요가 증가합니다. 이에 따라 방위산업기업들의 매출과 이익 증가가 예상되어 주가가 상승합니다.'),
(10, 10, 15, '무역전쟁으로 인해 관세가 부과되어 생산 비용이 증가하고 수출이 감소할 수 있습니다. 이에 따라 미국 전자기기 기업들의 수익성이 악화될 것으로 예상되어 주가가 하락합니다.'),
(11, 2, 7, '기업 실적이 예상보다 좋게 발표되면, 매출과 이익이 증가하여 기업의 재정 상태가 개선된다는 신호로 받아들여집니다. 투자자들이 이를 긍정적으로 평가하여 주식을 매수하게 되면서 주가가 상승합니다.'),
(12, -18, -25, '경영진 변화가 발표되면, 새로운 경영진의 능력과 전략에 대한 불확실성이 증가합니다. 투자자들이 이를 우려하여 주식을 매도하게 되면서 주가가 하락합니다.'),
(13, 4, 7, '어느 한 국가의 환율이 약화되면 해당 국가 기업의 가격 경쟁력이 강화됩니다. 원화 약세와 달러 강세로 인해 한국 수출 기업의 경쟁력이 강화되어 주가가 상승했습니다.'),
(14, -1, -3, '어느 한 국가의 환율이 강화되면 해당 국가 기업의 가격 경쟁력이 약화됩니다. 원화 약세와 달러 강세로 인해 미국 수출 기업들은 가격 경쟁력이 약화되어 주가가 하락했습니다.'),
(15, 14, 21, '원유 가격 상승으로 인해 에너지 기업의 매출과 이익이 증가할 것으로 예상됩니다. 이에 따라 에너지 기업들의 주가가 상승했습니다.'),
(16, -7, -11, '높은 인플레이션 발표로 인해 소비자 지출 감소와 기업 비용 증가가 예상됩니다. 이에 따라 기업들의 수익성 악화 우려로 주가가 하락합니다.');


/* EventGroup 테이블 추가 (주식이 그룹별로 나눠진 테이블, join 기능 이용하여 다른 테이블과 합칠 수 O) */
CREATE TABLE EventGroup (
    stock_id INT UNSIGNED NOT NULL,
    event_group INT(1) NOT NULL,
    PRIMARY KEY (stock_id, event_group),
    FOREIGN KEY (stock_id) REFERENCES Stock(stock_id)
);


/* EventGroup 테이블에 데이터 추가 */
INSERT INTO EventGroup (stock_id, event_group) VALUES (1, 1), (2, 1), (3, 1), (4, 1), (5, 2), (6, 2), (7, 2), (8, 2), (9, 3), (10, 3), (11, 3), (12, 3), (13, 4), (14, 4), (15, 4), (16, 4);


/* eventgroup 테이블이랑 eventstock 테이블 join하는 코드 예시입니다. (es는 둘을 join 한 테이블의 이름)
SELECT es.*, eg.event_group
FROM EventStock es
INNER JOIN EventGroup eg ON es.stock_id = eg.stock_id;
*/