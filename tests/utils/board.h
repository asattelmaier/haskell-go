#ifndef BOARD_H_
#define BOARD_H_ 



#include <nlohmann/json.hpp>



using namespace std;
using json = nlohmann::json;



namespace board {

  json get_board(json game, int position);

  string get_state(json board, int x, int y);
  
  bool has_state(json board, string state);

}



#endif
