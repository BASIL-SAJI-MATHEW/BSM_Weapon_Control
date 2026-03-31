-- BSM | Basil Saji Mathew
-- Weapon Control Disarm Table Schema

CREATE TABLE IF NOT EXISTS `bsm_weapon_disarm_states` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(100) NOT NULL UNIQUE,
    `disarmed_until` BIGINT(20) NOT NULL,
    `reason` VARCHAR(255) DEFAULT 'System',
    `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
