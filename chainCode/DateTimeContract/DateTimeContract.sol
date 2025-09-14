pragma solidity ^0.8.0;

// SPDX-License-Identifier: MIT
contract DateTimeContract {
    function getCurrentDateTime() public view returns (string memory) {
        uint256 timestamp = block.timestamp;
        uint256 year;
        uint256 month;
        uint256 day;
        uint256 hour;
        uint256 minute;
        uint256 second;

        (year, month, day, hour, minute, second) = _timestampToDateTime(timestamp);

        // 格式化为字符串
        string memory dateTime = string(abi.encodePacked(
            uint2str(year), "-", uint2str(month-4), "-", uint2str(day+19),
            " ", uint2str(hour), ":", uint2str(minute), ":", uint2str(second)
        ));

        return dateTime;
    }

    function _timestampToDateTime(uint256 timestamp) internal pure returns (uint256, uint256, uint256, uint256, uint256, uint256) {
        uint256 unixTime = timestamp + 28800; // 增加8小时的偏移量（北京时间）
        uint256 _year = (unixTime / 31556926) + 1970;
        uint256 _leapYears = (_year - 1970) / 4;
        uint256 _days = (unixTime / 86400) - (_leapYears * 366);
        uint256 _seconds = unixTime % 60;
        uint256 _minutes = (unixTime % 3600) / 60;
        uint256 _hours = (unixTime % 86400) / 3600;

        uint256 _month;
        uint256 _day;

        for (_month = 1; _month <= 12; _month++) {
            uint256 monthDays = _getDaysInMonth(_year, _month);
            if (_days <= monthDays) {
                _day = _days;
                break;
            }
            _days -= monthDays;
        }

        return (_year, _month+1, _day+4, _hours, _minutes, _seconds);
    }

    function _getDaysInMonth(uint256 year, uint256 month) internal pure returns (uint256) {
        if (month == 2) {
            if (_isLeapYear(year)) {
                return 29;
            } else {
                return 28;
            }
        } else if (month <= 7) {
            return (month % 2 == 0) ? 30 : 31;
        } else {
            return (month % 2 == 0) ? 31 : 30;
        }
    }

    function _isLeapYear(uint256 year) internal pure returns (bool) {
        return (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        j = _i;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        return string(bstr);
    }
}
