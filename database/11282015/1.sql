-- phpMyAdmin SQL Dump
-- version 4.3.11
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Nov 28, 2015 at 01:03 PM
-- Server version: 5.6.24
-- PHP Version: 5.5.24

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `pss_v1`
--

-- --------------------------------------------------------

--
-- Table structure for table `queries`
--

CREATE TABLE IF NOT EXISTS `queries` (
  `id` bigint(20) NOT NULL,
  `code` varchar(300) NOT NULL,
  `details` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `queries`
--

INSERT INTO `queries` (`id`, `code`, `details`) VALUES
(1, 'add_event_log', 'INSERT INTO activity_trail (_user_id, activity_code, result, uri, log_details, ip_address, event_time)\nVALUES (''_USER_ID_'', ''_ACTIVITY_CODE_'', ''_RESULT_'', ''_URI_'', ''_LOG_DETAILS_'', ''_IP_ADDRESS_'', NOW())'),
(2, 'get_user_by_name_and_pass', 'SELECT id AS user_id, user_name, email_address, first_name  FROM users WHERE user_name=''_LOGIN_NAME_'' AND password=''_LOGIN_PASSWORD_'' AND status=''active'''),
(3, 'get_user_by_id', 'SELECT U.id, U._organization_id AS organization_id, U.user_name, U.id AS user_id, U.first_name, U.last_name, U.email_address, U.email_verified, U.telephone, U._telephone_carrier_id AS carrier_id, U.photo_url, \n(SELECT carrier_name FROM telephone_carriers WHERE id=U._telephone_carrier_id LIMIT 1) AS telephone_carrier, \n(SELECT type FROM permission_groups WHERE id=U._permission_group_id LIMIT 1) AS group_type\n\nFROM users U \nWHERE id=''_USER_ID_'''),
(4, 'get_user_permissions', 'SELECT P.code AS permission_code FROM users U  \nLEFT JOIN permission_group_mapping PM ON (U._permission_group_id=PM._group_id) \nLEFT JOIN permissions P ON (PM._permission_id=P.id) \nWHERE U.id=''_USER_ID_'' AND P.code IS NOT NULL'),
(5, 'get_user_group_type', 'SELECT G.type AS group_type FROM users U \nLEFT JOIN permission_groups G ON (G.id=U._permission_group_id) \nWHERE U.id=''_USER_ID_'''),
(6, 'get_business_categories', 'SELECT * FROM business_categories'),
(7, 'get_countries_list', 'SELECT * FROM countries ORDER BY display_order ASC, name ASC'),
(8, 'get_secret_questions', 'SELECT * FROM secret_questions ORDER BY question ASC'),
(9, 'check_user_name', 'SELECT * FROM users WHERE user_name=''_USER_NAME_'''),
(10, 'get_government_ministries', 'SELECT * FROM ministries ORDER BY name'),
(11, 'get_best_evaluated_bidders', 'SELECT N.name AS notice_name, N.category, N.note, N.display_start_date AS posted_date, \n(SELECT name FROM organizations WHERE id=B._organization_id LIMIT 1) AS entity_name, \n(SELECT name FROM organizations WHERE id=B._submitted_by LIMIT 1) AS provider_name, \nN.deadline\n\nFROM bids B\nLEFT JOIN tender_notices N ON (B._tender_notice_id=N.id)\nLEFT JOIN bid_status BS ON (B.id=BS._bid_id AND BS.status=''won'')\n\nWHERE BS._bid_id IS NOT NULL \nORDER BY BS.date_entered DESC \n_LIMIT_TEXT_'),
(12, 'get_message_template', 'SELECT *, copy_admin AS copyadmin FROM message_templates WHERE message_type=''_MESSAGE_TYPE_'''),
(13, 'record_message_exchange', 'INSERT INTO message_exchange (_template_id, details, `subject`, attachment_url, _sender_id, _recipient_id, date_entered)\r\n\r\n(SELECT T.id AS _template_id, ''_DETAILS_'' AS details, ''_SUBJECT_'' AS `subject`, ''_ATTACHMENT_URL_'' AS attachment_url, \r\n''_SENDER_ID_'' AS _sender_id, \r\nU.id AS _recipient_id, NOW() AS date_entered\r\nFROM message_templates T LEFT JOIN users U ON (U.id IN (''_RECIPIENT_ID_'')) WHERE T.message_type=''_TEMPLATE_CODE_'')\r\n\r\nON DUPLICATE KEY UPDATE `subject`=VALUES(`subject`), details=VALUES(details), attachment_url=VALUES(attachment_url), date_entered=VALUES(date_entered)'),
(14, 'get_accounts_of_type', 'SELECT U.id AS _user_id FROM users U \nLEFT JOIN permission_groups G ON (U._permission_group_id=G.id) \nWHERE G.type=''_ACCOUNT_TYPE_'' \nGROUP BY U.id '),
(15, 'save_temp_organization', 'INSERT INTO organizations (name, description, _owner_user_id,  _registration_country_id, registration_number, tax_id, _category_id, _ministry_id, date_established, date_entered, _entered_by, last_updated, _last_updated_by) VALUES \n(''_NAME_'', ''_DESCRIPTION_'', ''_USER_ID_'', ''_REGISTRATION_COUNTRY_ID_'', ''_REGISTRATION_NUMBER_'', ''_TAX_ID_'', ''_CATEGORY_ID_'', ''_MINISTRY_ID_'', ''_DATE_ESTABLISHED_'', NOW(), ''_USER_ID_'', NOW(), ''_USER_ID_'')\n\nON DUPLICATE KEY UPDATE id=LAST_INSERT_ID(id), _registration_country_id=VALUES(_registration_country_id), registration_number=VALUES(registration_number),_category_id=VALUES(_category_id), _ministry_id=VALUES(_ministry_id), date_established=VALUES(date_established), last_updated=NOW(), _last_updated_by=''_USER_ID_'''),
(16, 'save_temp_user', 'INSERT INTO users (email_address, telephone, country, user_name, password, secret_answer, secret_question, date_entered, last_updated) \n(SELECT ''_EMAIL_ADDRESS_'' AS email_address, ''_TELEPHONE_'' AS telephone, ''_COUNTRY_'' AS country, ''_USER_NAME_'' AS user_name, ''_PASSWORD_'' AS password, ''_SECRET_ANSWER_'' AS secret_answer, \n(SELECT question FROM secret_questions WHERE id=''_SECRET_QUESTION_ID_'') AS secret_question, \nNOW() AS date_entered, NOW() AS last_updated) \n\nON DUPLICATE KEY UPDATE id=LAST_INSERT_ID(id), telephone=VALUES(telephone), password=VALUES(password), secret_answer=VALUES(secret_answer), secret_question=VALUES(secret_question), last_updated=NOW()'),
(17, 'remove_temp_user', 'DELETE FROM users WHERE id=''_USER_ID_'''),
(18, 'remove_temp_organization', 'DELETE FROM organizations WHERE id=''_ORGANIZATION_ID_'''),
(19, 'update_organization_contact', 'UPDATE organizations SET contact_address=''_CONTACT_ADDRESS_'', contact_city=''_CONTACT_CITY_'', contact_region=''_CONTACT_REGION_'', contact_zipcode=''_CONTACT_ZIPCODE_'', contact_country_id=''_CONTACT_COUNTRY_ID_''\r\n\r\nWHERE id=''_ORGANIZATION_ID_'''),
(20, 'activate_user_account', 'UPDATE users SET \nfirst_name=''_FIRST_NAME_'', last_name=''_LAST_NAME_'', _organization_id=''_ORGANIZATION_ID_'', email_verified=''Y'', status=''active'', _entered_by=''_USER_ID_'', last_updated=NOW(), _last_updated_by=''_USER_ID_'',\n _permission_group_id = (SELECT id FROM permission_groups WHERE type=''_ORGANIZATION_TYPE_'' AND is_removable=''N'' LIMIT 1)\n\n WHERE id=''_USER_ID_'''),
(21, 'get_audit_trail', 'SELECT T.event_time AS event_date, T.result, T.uri, T.ip_address,   \n(SELECT CONCAT(first_name, '' '', last_name) FROM users WHERE id=T._user_id) AS name, \nREPLACE(T.activity_code, ''_'', '' '') AS activity_code, \nREPLACE(REPLACE(T.log_details, ''|'', ''<br>''), ''='', '' = '') AS details\n\nFROM activity_trail T \nWHERE 1=1 _DATE_CONDITION_ _USER_CONDITION_ _ACTIVITY_CONDITION_ _PHRASE_CONDITION_ \nORDER BY event_time DESC \n_LIMIT_TEXT_ \n'),
(22, 'search_user_list', 'SELECT id AS user_id, CONCAT(first_name, '' '', last_name) AS name FROM users WHERE first_name LIKE CONCAT(''%'',''_PHRASE_'',''%'') OR last_name LIKE CONCAT(''%'',''_PHRASE_'',''%'') OR email_address LIKE CONCAT(''%'',''_PHRASE_'',''%'') \r\n\r\n_LIMIT_TEXT_'),
(23, 'get_activity_codes', 'SELECT DISTINCT activity_code AS code, REPLACE(activity_code, ''_'', '' '') AS display_code FROM activity_trail \nWHERE activity_code <> '''' AND activity_code IS NOT NULL \nORDER BY activity_code'),
(24, 'get_user_list', 'SELECT id AS user_id, CONCAT(first_name, '' '', last_name) AS name, email_address, telephone, status, date_entered AS date_created, _permission_group_id AS group_id, \n(SELECT name FROM countries WHERE id=U.country LIMIT 1) AS country, \n(SELECT name FROM organizations WHERE id=U._organization_id LIMIT 1) AS organization,\n(SELECT name FROM permission_groups WHERE id=U._permission_group_id LIMIT 1) AS permission_group,\n(SELECT type FROM permission_groups WHERE id=U._permission_group_id LIMIT 1) AS user_type\n\nFROM users U WHERE 1=1 _ORGANIZATION_CONDITION_ _PHRASE_CONDITION_ _TYPE_CONDITION_ _LIMIT_TEXT_'),
(25, 'get_permissions_by_group_id', 'SELECT P.display AS permission FROM permission_group_mapping M LEFT JOIN permissions P ON (M._permission_id=P.id) WHERE M._group_id=''_GROUP_ID_'''),
(26, 'update_user_status', 'UPDATE users SET status=''_NEW_STATUS_'' WHERE id IN (''_USER_LIST_'')'),
(27, 'update_organization_status', 'UPDATE organizations SET status = ''_NEW_STATUS_'' WHERE id IN (SELECT DISTINCT _organization_id FROM users WHERE id IN (''_USER_LIST_''))'),
(28, 'get_provider_list', 'SELECT O.id AS organization_id, O.name, O.tax_id, O.rop_number, O.status, O.date_established AS date_registered, O.date_entered AS date_created, \n(SELECT CONCAT(first_name, '' '', last_name) FROM users WHERE id=O._owner_user_id LIMIT 1) AS contact_name, \nIF(O._category_id > 0, (SELECT name FROM business_categories WHERE id=O._category_id LIMIT 1), '''') AS category, \nIF(O._ministry_id > 0, (SELECT name FROM ministries WHERE id=O._ministry_id LIMIT 1), '''') AS ministry, \n(SELECT name FROM countries WHERE id=O._registration_country_id LIMIT 1) AS country, \nCONCAT(contact_address, '' '', '', '', contact_city, '', '', contact_region, '' '', contact_zipcode, '', '',(SELECT name FROM countries WHERE id=contact_country_id LIMIT 1)) AS address\n\nFROM organizations O \nWHERE (SELECT G.type FROM users U LEFT JOIN permission_groups G ON (G.id=U._permission_group_id) WHERE U.id=O._owner_user_id LIMIT 1) = ''provider'' _CATEGORY_CONDITION_ _MINISTRY_CONDITION_ _COUNTRY_CONDITION_ _PHRASE_CONDITION_ \n_LIMIT_TEXT_'),
(29, 'get_tender_list', 'SELECT T.id AS tender_id, T.name AS subject, T.category AS procurement_type, T.method AS procurement_method, T.deadline, T.display_start_date, T.display_end_date, T.status, T.date_entered AS date_created, T._procurement_plan_id AS plan_id, \n\nIFNULL((SELECT id FROM bids WHERE _tender_notice_id=T.id AND _organization_id=''_ORGANIZATION_ID_'' AND status IN (''submitted'',''under_review'',''won'',''awarded'',''complete'') LIMIT 1), '''') AS bid_id, \n\n(SELECT title FROM procurement_plans WHERE id=T._procurement_plan_id LIMIT 1) AS procurement_plan, \n\n(SELECT _organization_id FROM procurement_plans WHERE T._procurement_plan_id=id LIMIT 1) AS pde_id, \n\n(SELECT O.name FROM procurement_plans P LEFT JOIN organizations O ON (P._organization_id=O.id) WHERE T._procurement_plan_id=P.id LIMIT 1) AS pde\n\nFROM tender_notices T \n\nWHERE 1=1 _METHOD_CONDITION_ _TYPE_CONDITION_ _STATUS_CONDITION_ _OWNER_CONDITION_ _PHRASE_CONDITION_ _DEADLINE_CONDITION_ \n_PDE_CONDITION_ \n_LIMIT_TEXT_ '),
(30, 'get_procurement_plan_list', 'SELECT P._organization_id AS pde_id, P.id AS procurement_plan_id, P.title AS name, P.financial_year_start, P.financial_year_end, P.status, P.date_entered AS date_created, \n(SELECT name FROM organizations WHERE id=P._organization_id LIMIT 1) AS pde\n\nFROM procurement_plans P WHERE 1=1 _PDE_CONDITION_ _STATUS_CONDITION_ _PHRASE_CONDITION_ _LIMIT_TEXT_ '),
(31, 'get_bid_list', 'SELECT B.id AS bid_id, B.date_submitted, B.summary, B.bid_amount, B.bid_currency, B.final_contract_amount, B.final_amount_currency, B.valid_start_date, B.valid_end_date, B.status, B.last_updated, B._organization_id AS provider_id, B._tender_notice_id AS tender_id,  \n\n(SELECT name FROM organizations WHERE id = B._organization_id LIMIT 1) AS provider, \n\n(SELECT O.name FROM tender_notices N LEFT JOIN organizations O ON (N._organization_id=O.id) WHERE N.id=B._tender_notice_id LIMIT 1) AS pde, \n\n(SELECT N._organization_id FROM tender_notices N WHERE N.id=B._tender_notice_id LIMIT 1) AS pde_id, \n\n(SELECT P.title FROM tender_notices N LEFT JOIN procurement_plans P ON (P.id=N._procurement_plan_id) WHERE N.id=B._tender_notice_id LIMIT 1) AS procurement_plan, \n\n(SELECT GROUP_CONCAT(document_url) FROM bid_documents WHERE _bid_id=B.id) AS documents, \n\n(SELECT name FROM tender_notices WHERE id = B._tender_notice_id LIMIT 1) AS tender_notice,\n\nIFNULL((SELECT id FROM contracts WHERE _tender_id=B._tender_notice_id AND  _organization_id=B._organization_id LIMIT 1), 0) AS contract_id \n\nFROM bids B \n\nWHERE 1=1 _STATUS_CONDITION_ _PHRASE_CONDITION_ _PDE_CONDITION_ \n\n_LIMIT_TEXT_'),
(32, 'search_pde_list', 'SELECT O.id AS pde_id, O.name \nFROM organizations O LEFT JOIN users U ON (O._owner_user_id=U.id) LEFT JOIN permission_groups G ON (U._permission_group_id=G.id) \n\nWHERE G.type = ''pde'' AND O.name LIKE ''%_PHRASE_%'' _LIMIT_TEXT_'),
(34, 'get_procurement_methods', 'SELECT code, method FROM procurement_methods'),
(35, 'search_procurement_plan_list', 'SELECT id AS plan_id, CONCAT(''&#x25FE; '', (SELECT name FROM organizations WHERE id=P._organization_id LIMIT 1),'' ['', title,'' - '', DATE_FORMAT(financial_year_start,''%Y''),'' TO '',DATE_FORMAT(financial_year_end,''%Y''), '']'') AS name FROM procurement_plans P WHERE title LIKE ''%_PHRASE_%''\n_LIMIT_TEXT_'),
(36, 'add_procurement_plan', 'INSERT INTO procurement_plans (_organization_id, financial_year_start, financial_year_end, title, details, document_url, status, date_entered, _entered_by, last_updated, _last_updated_by) VALUES (''_ORGANIZATION_ID_'', ''_FINANCIAL_YEAR_START_'', ''_FINANCIAL_YEAR_END_'', ''_TITLE_'', ''_DETAILS_'', ''_DOCUMENT_URL_'', ''_STATUS_'', NOW(), ''_USER_ID_'', NOW(), ''_USER_ID_'')'),
(37, 'add_tender_notice', 'INSERT INTO tender_notices (name, details, category, method, _organization_id, _procurement_plan_id, document_url, deadline, display_start_date, display_end_date, status, date_entered, _entered_by, last_updated, _last_updated_by) \n\n(SELECT ''_NAME_'' AS name, ''_DETAILS_'' AS details, ''_CATEGORY_'' AS category, ''_METHOD_'' AS method, \n(SELECT _organization_id FROM procurement_plans WHERE id=''_PROCUREMENT_PLAN_ID_'' LIMIT 1) AS _organization_id, ''_PROCUREMENT_PLAN_ID_'' AS _procurement_plan_id, ''_DOCUMENT_URL_'' AS document_url, ''_DEADLINE_'' AS deadline, ''_DISPLAY_START_DATE_'', ''_DISPLAY_END_DATE_'', ''_STATUS_'', NOW(), ''_USER_ID_'', NOW(), ''_USER_ID_'')'),
(38, 'get_organization_details_by_id', 'SELECT id AS organization_id, name, description, tax_id, registration_number, status, date_entered, last_updated, \n\n(SELECT CONCAT(first_name, '' '', last_name) FROM users WHERE id=O._owner_user_id LIMIT 1) AS owner, \n\nIFNULL(logo_url, '''') AS logo_url, \n\n(SELECT name FROM countries WHERE id = O._registration_country_id LIMIT 1) AS registration_country, \n\nIF(O._ministry_id > 0, (SELECT name FROM ministries WHERE id=O._ministry_id LIMIT 1), (SELECT name FROM business_categories WHERE id=O._category_id LIMIT 1)) AS category_or_ministry, \n\n(SELECT CONCAT(contact_address, '', '', contact_city, '', '', contact_region,'' '', contact_zipcode, '', '', (SELECT name FROM countries WHERE id=O.contact_country_id LIMIT 1)) ) AS address, \n\nIF(O.date_established = ''0000-00-00'', '''', O.date_established) AS date_established, \n\n(SELECT CONCAT(first_name, '' '', last_name) FROM users WHERE id=O._entered_by LIMIT 1) AS entered_by, \n\n(SELECT CONCAT(first_name, '' '', last_name) FROM users WHERE id=O._last_updated_by LIMIT 1) AS last_updated_by\n\nFROM organizations O \nWHERE id=''_ORGANIZATION_ID_'''),
(39, 'get_tender_notice', 'SELECT N.id AS tender_id, N.name, N.details AS description, N.category AS type, N.method, N.document_url, N.deadline, N.display_start_date, N.display_end_date, N.status, N.date_entered, N.last_updated, \n(SELECT CONCAT(first_name, '' '', last_name) FROM users WHERE id=N._entered_by LIMIT 1) AS entered_by, \n(SELECT CONCAT(first_name, '' '', last_name) FROM users WHERE id=N._last_updated_by LIMIT 1) AS last_updated_by, \n(SELECT name FROM organizations WHERE id = N._organization_id LIMIT 1) AS pde, \n(SELECT title FROM procurement_plans WHERE id=N._procurement_plan_id LIMIT 1) AS procurement_plan\n\nFROM tender_notices N \nWHERE N.id = ''_TENDER_ID_'''),
(40, 'get_procurement_plan', 'SELECT P._organization_id AS pde_id, P.id AS procurement_plan_id, P.title AS name, P.details, P.document_url, P.financial_year_start, P.financial_year_end, P.status, P.date_entered, P.last_updated, \n(SELECT name FROM organizations WHERE id=P._organization_id LIMIT 1) AS pde, \n\n(SELECT CONCAT(first_name, '' '', last_name) FROM users WHERE id=P._entered_by LIMIT 1) AS entered_by, \n\n(SELECT CONCAT(first_name, '' '', last_name) FROM users WHERE id=P._last_updated_by LIMIT 1) AS last_updated_by\n\nFROM procurement_plans P \n\nWHERE id=''_PLAN_ID_'''),
(41, 'update_tender_status', 'UPDATE tender_notices SET status = ''_NEW_STATUS_'' WHERE id IN (''_ID_LIST_'')'),
(42, 'get_currency_list', 'SELECT code AS currency_code, CONCAT(code, '' - '', name) AS display FROM currencies WHERE name LIKE ''%_PHRASE_%'' ORDER BY display_order _LIMIT_TEXT_'),
(43, 'get_my_bid_list', 'SELECT B.id AS bid_id, B.date_submitted, B.summary, B.bid_amount, B.bid_currency, B.final_contract_amount, B.final_amount_currency, B.valid_start_date, B.valid_end_date, B.status, B.last_updated, B._organization_id AS provider_id, B._tender_notice_id AS tender_id, \n\n(SELECT name FROM organizations WHERE id = B._organization_id LIMIT 1) AS provider, \n\n(SELECT O.name FROM tender_notices N LEFT JOIN organizations O ON (N._organization_id=O.id) WHERE N.id=B._tender_notice_id LIMIT 1) AS pde, \n\n(SELECT N._organization_id FROM tender_notices N WHERE N.id=B._tender_notice_id LIMIT 1) AS pde_id, \n\n(SELECT P.title FROM tender_notices N LEFT JOIN procurement_plans P ON (P.id=N._procurement_plan_id) WHERE N.id=B._tender_notice_id LIMIT 1) AS procurement_plan, \n\n(SELECT name FROM tender_notices WHERE id = B._tender_notice_id LIMIT 1) AS tender_notice, \n\n(SELECT GROUP_CONCAT(document_url) FROM bid_documents WHERE _bid_id=B.id) AS documents, \n\n(SELECT GROUP_CONCAT(CONCAT(UPPER(status),'' ('',DATE_FORMAT(date_entered,''%d/%m/%Y''),'' TO '',IF(end_date <> ''0000-00-00'', DATE_FORMAT(end_date,''%d/%m/%Y''),''NOW''),'')'') SEPARATOR ''<BR>'') \nFROM bid_status WHERE _bid_id=B.id ORDER BY date_entered DESC) AS status_trail \n\nFROM bids B \n\nWHERE 1=1 _SUBMIT_PERIOD_ _STATUS_CONDITION_\nHAVING 1=1 _PDE_CONDITION_ \n\n_LIMIT_TEXT_'),
(44, 'add_bid_record', 'INSERT INTO bids (_organization_id, _submitted_by, date_submitted, _tender_notice_id, bid_amount, bid_currency, summary, valid_start_date, valid_end_date, status, last_updated)\r\n\r\n(SELECT ''_ORGANIZATION_ID_'' AS _organization_id, IF(''_STATUS_''=''submitted'', ''_USER_ID_'', '''') AS _submitted_by, IF(''_STATUS_''=''submitted'', NOW(), ''0000-00-00'') AS date_submitted, ''_TENDER_ID_'' AS _tender_notice_id, ''_BID_AMOUNT_'' AS bid_amount, ''_BID_CURRENCY_'' AS bid_currency, ''_SUMMARY_'' AS summary, ''_VALID_START_DATE_'' AS valid_start_date, ''_VALID_END_DATE_'' AS valid_end_date, ''_STATUS_'' AS status, NOW() AS last_updated )'),
(45, 'add_bid_status', 'INSERT IGNORE INTO bid_status (_bid_id, status, date_entered, _entered_by) VALUES (''_BID_ID_'', ''_STATUS_'', NOW(), ''_USER_ID_'')'),
(46, 'add_bid_document', 'INSERT INTO bid_documents (_bid_id, document_url, date_entered, _entered_by, last_updated, 	_last_updated_by) VALUES (''_BID_ID_'', ''_DOCUMENT_URL_'', NOW(), ''_USER_ID_'', NOW(), ''_USER_ID_'')'),
(47, 'get_basic_bid', 'SELECT * FROM bids WHERE id=''_BID_ID_'''),
(48, 'update_status_trail', 'UPDATE bid_status SET end_date=NOW() WHERE end_date=''0000-00-00 00:00:00'' AND _bid_id IN (''_BID_IDS_'')'),
(49, 'add_status_trail', 'INSERT INTO bid_status (_bid_id, status, date_entered, _entered_by)\n\n(SELECT B.id AS _bid_id, ''_NEW_STATUS_'' AS status, NOW() AS date_entered, ''_USER_ID_'' AS _entered_by FROM bids B WHERE id IN (''_BID_IDS_''))'),
(50, 'update_bid_status', 'UPDATE bids SET status=''_NEW_STATUS_'', last_updated=NOW() WHERE id IN (''_BID_IDS_'')'),
(51, 'submit_provider_bid', 'UPDATE bids SET status=''submitted'', last_updated=NOW(), _submitted_by=''_USER_ID_'', date_submitted=NOW() WHERE id IN (''_BID_IDS_'')'),
(52, 'get_bid_provider_users', 'SELECT U.id AS user_id FROM bids B LEFT JOIN users U ON (U._organization_id=B._organization_id) \r\nWHERE B.id = ''_BID_ID_'' AND U.id IS NOT NULL'),
(53, 'get_contract_list', 'SELECT C.id AS contract_id, C._tender_id AS tender_id, C.name, C.contract_currency, C.contract_amount, C.progress_percent, C.date_started, C.status, C.last_updated,\n\n(SELECT name FROM organizations WHERE id = C._organization_id LIMIT 1) AS provider, \n\n(SELECT O.name FROM tender_notices N LEFT JOIN organizations O ON (N._organization_id=O.id) WHERE N.id=C._tender_id LIMIT 1) AS pde,\n\n(SELECT N._organization_id FROM tender_notices N WHERE N.id=C._tender_id LIMIT 1) AS pde_id,\n\n(SELECT N.name FROM tender_notices N WHERE N.id=C._tender_id LIMIT 1) AS tender_notice,\n\nIF((SELECT id FROM contract_status WHERE _contract_id=C.id LIMIT 1) IS NOT NULL, ''Y'', ''N'') AS has_notes,\n(SELECT CONCAT(first_name, '' '', last_name) FROM users WHERE id=C._last_updated_by LIMIT 1) AS last_updated_by\n\nFROM contracts C \nWHERE 1=1 _TENDER_CONDITION_ _PDE_CONDITION_ _STATUS_CONDITION_ _OWNER_CONDITION_ _PHRASE_CONDITION_ _LIMIT_TEXT_'),
(54, 'search_tender_list', 'SELECT id AS tender_id, name, \n(SELECT _organization_id FROM contracts WHERE _tender_id=T.id LIMIT 1) AS provider_id\n\nFROM tender_notices T WHERE name LIKE ''%_PHRASE_%'' _OWNER_CONDITION_ _LIMIT_TEXT_'),
(55, 'add_contract_record', 'INSERT INTO contracts (_tender_id, _organization_id, _pde_id, name, contract_currency, contract_amount, date_started, status, 	date_entered, _entered_by, last_updated, _last_updated_by) VALUES \r\n(''_TENDER_ID_'', ''_ORGANIZATION_ID_'', ''_PDE_ID_'', ''_NAME_'', ''_CONTRACT_CURRENCY_'', ''_CONTRACT_AMOUNT_'', ''_DATE_STARTED_'', ''_STATUS_'', NOW(), ''_USER_ID_'', NOW(), ''_USER_ID_'')'),
(56, 'add_contract_status', 'INSERT INTO contract_status (_contract_id, percentage, status, document_urls, notes, date_entered, _entered_by, _entered_by_organization_id) VALUES \n(''_CONTRACT_ID_'', ''_PERCENTAGE_'', ''_STATUS_'', ''_DOCUMENT_URL_'', ''_NOTES_'', NOW(), ''_USER_ID_'', ''_ORGANIZATION_ID_'')'),
(57, 'update_bid_contract_amount', 'UPDATE bids SET final_contract_amount=''_CONTRACT_AMOUNT_'', final_amount_currency=''_CONTRACT_CURRENCY_'', last_updated=NOW(), _last_updated_by=''_USER_ID_'' WHERE _tender_notice_id=''_TENDER_ID_'' AND _organization_id=''_ORGANIZATION_ID_''\r\n'),
(58, 'get_contract_notes', 'SELECT status, percentage, document_urls AS documents, notes, date_entered, \n(SELECT CONCAT(first_name, '' '', last_name) FROM users WHERE id=CS._entered_by LIMIT 1) AS entered_by,\n(SELECT name FROM organizations WHERE id=CS._entered_by_organization_id LIMIT 1) AS entered_by_organization\n\nFROM contract_status CS \nWHERE _contract_id=''_CONTRACT_ID_'' \n_LIMIT_TEXT_'),
(59, 'update_contract_percentage', 'UPDATE contracts SET progress_percent=''_PERCENTAGE_'', last_updated=NOW(), _last_updated_by=''_USER_ID_'' WHERE id=''_CONTRACT_ID_'''),
(60, 'get_user_by_email_address', 'SELECT\r\n  U.id,\r\n  U._organization_id      AS organization_id,\r\n  U.user_name,\r\n  U.id                    AS user_id,\r\n  U.first_name,\r\n  U.last_name,\r\n  U.email_address,\r\n  U.email_verified,\r\n  U.telephone,\r\n  U._telephone_carrier_id AS carrier_id,\r\n  U.photo_url,\r\n  (SELECT carrier_name\r\n   FROM telephone_carriers\r\n   WHERE id = U._telephone_carrier_id\r\n   LIMIT 1)               AS telephone_carrier,\r\n  (SELECT type\r\n   FROM permission_groups\r\n   WHERE id = U._permission_group_id\r\n   LIMIT 1)               AS group_type\r\n  FROM users U \r\nWHERE \r\nemail_address = ''_EMAIL_''');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `queries`
--
ALTER TABLE `queries`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `queries`
--
ALTER TABLE `queries`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=61;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
