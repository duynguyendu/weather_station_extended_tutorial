
#include "server_receiver.c"
#include "token.h"
#include <kos.h>

// Declare a set of static token slots for our message server communications

// Declare our msg server client instance
// NB: This instance is global because it should always be in scope for the
// life-time of the thread. However, it is not thread-safe - each thread
// should be given its own message server client instance.
kos_msg_client_t client = {0};

/*
 * Create a high-level connection to the message server
 * so that the C application can use or bind ports.
 */
void setup_msg_server() {
  kos_status_t status;
  kos_cap_t receive_cap = kos_cnode_cap(kos_app_cnode(), KOS_ROOT_RECEIVE);
  kos_cap_set_receive(receive_cap);

  status = kos_msg_setup();
  kos_assert_created(status, "kos_msg_setup");

  kos_cap_t client_cap = kos_cap_reserve();
  status = kos_msg_client_create(client_cap, TOKEN_CLIENT, &client);
  kos_assert_created(status, "kos_msg_client_create");
}

int main(int argc, char *argv[]) {
  kos_status_t status;

  kos_printf("Initializing LED app\n");

  // Signal that we are done initializing
  kos_app_ready();

  // Implement normal runtime logic here

  setup_msg_server();

  // Connect to the log port
  status = kos_dir_request("kos_log_protocol", TOKEN_LOGGING,
                           KOS_MSG_FLAG_SEND_TOKEN, NULL);
  kos_assert_ok(status, "Request logging service");
  // Use the logging service to print a message
  kos_log_info(TOKEN_LOGGING, "Hello Log Server", 0);

  start_receive_server();

  // Suspend the app
  kos_tcb_suspend(KOS_ROOT_SLOT_TCB);
  return 0;
}
