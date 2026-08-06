import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ad_manager.dart';

/// A generic manager to handle in-app virtual currencies (e.g., Gold, Gems).
/// Simplifies the flow of purchasing items and automatically showing rewarded ads 
/// when the user has insufficient funds.
class EconomyManager {
  /// Attempts to spend currency. If the user doesn't have enough, it automatically 
  /// shows a generic "Not Enough Currency" dialog offering to watch an ad.
  ///
  /// [currentBalance] The user's current currency amount.
  /// [cost] The amount required to spend.
  /// [currencyName] The name of the currency (e.g., 'Gold', 'Gems') to display in UI.
  /// [rewardAmount] The amount of currency to reward if the user watches an ad.
  /// [onSuccess] Callback executed if the user has enough currency.
  /// [onRewardEarned] Callback executed when the user successfully watches an ad.
  static void spendCurrency({
    required BuildContext context,
    required int currentBalance,
    required int cost,
    required String currencyName,
    required int rewardAmount,
    required VoidCallback onSuccess,
    required VoidCallback onRewardEarned,
  }) {
    if (currentBalance >= cost) {
      onSuccess();
    } else {
      _showNotEnoughCurrencyDialog(
        context: context,
        currencyName: currencyName,
        rewardAmount: rewardAmount,
        onRewardEarned: onRewardEarned,
      );
    }
  }

  /// Displays a dialog informing the user they don't have enough currency, 
  /// with a button to watch a rewarded ad to earn more.
  static void _showNotEnoughCurrencyDialog({
    required BuildContext context,
    required String currencyName,
    required int rewardAmount,
    required VoidCallback onRewardEarned,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${'not_enough'.tr} $currencyName'),
        content: Text('${'msg_not_enough_currency_desc'.tr} $rewardAmount $currencyName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('btn_cancel'.tr),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.tv),
            label: Text('btn_watch_ad_for_reward'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _showAd(onRewardEarned);
            },
          ),
        ],
      ),
    );
  }

  static void _showAd(VoidCallback onRewardEarned) {
    AdManager.showRewardedAd(
      onUserEarnedReward: (reward) {
        onRewardEarned();
      },
      onAdDismissed: () {
        // Handle ad dismissal if necessary
      },
    );
  }
}
